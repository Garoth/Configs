# mbox.py - qimport patches from mailboxes
#
# Copyright 2008 Patrick Mezard <pmezard@gmail.com>
#
# This extension was heavily inspired by Chris Mason mseries utility
# which can be found here:
#
#    http://oss.oracle.com/~mason/mseries/
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General
# Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

'''qimport patches from mailboxes

This extension let you read patches from mailboxes and append them to an
existing Mercurial Queue as the qimport command would do. Patch selection
is done interactively.

To enable this extension:

  [extensions]
  hgext.mbox =
  # MQ extension must be enabled as well
  hgext.mq =

  [mbox]
  # A list of mailboxes paths separated by the platform specific path separator,
  # colon on unixes, semi-colon on Windows.
  paths = mailbox1_path;mailbox_path2
'''

import email, mailbox, os, re, time, quopri
from mercurial import commands, hg, util, extensions, tempfile
from mercurial.i18n import gettext, _

class parseerror(Exception):
    """An error occured trying to parse an email message with a patch"""

# Here is what you receive in mercurial-devel when a MTA has changed
# the encoding to MIME quoted-printable:
# '=?cp1252?q?=5BPATCH_1_of_2=5D_Fix_issue_1782_don=92t_do_url2pathname_conv?=\n\t=?cp1252?q?ersion_for_urls?='
re_quopri = re.compile(r'^=\?([^\?]+)\?q\?(.*)\?=$')

def parsequopri(s):
    """If s is encoded as quoted-printable then convert to utf-8 encoding"""
    if not s.startswith('=?') or not s.endswith('?='):
        return s
    lines = []
    for line in s.splitlines():
        line = line.strip('\r\n\t')
        m = re_quopri.search(line)
        if not m:
            return s
        encoding, text = m.group(1, 2)
        lines.append(quopri.decodestring(text, True).decode(encoding))
    return ''.join(lines).encode('utf-8')

re_mailheaderlinebreak = re.compile('\r?\n[ \t]', re.M)
re_patchsubject = re.compile(r'^.*\[PATCH(?:\s+(\d+)\s+of\s+(\d+))?\]\s*(.+)$')

def parsesubject(s):
    """Return unbroken subject, title, index and total count from
    patchbomb subject
    """
    s = re_mailheaderlinebreak.sub(' ', s)
    m = re_patchsubject.search(s)
    if not m:
        raise parseerror(_('does not look like a patch message'))
    try:
        index = int(m.group(1))
        count = int(m.group(2)) + 1
    except (TypeError, IndexError):
        index = 0
        count = 1
    if count < 1:
        raise parseerror(_('invalid patch count: %d') % count)
    title = m.group(3)
    return s, title, index, count

class patchmessage:
    """An email message containing a patch"""
    def __init__(self, msg):
        """Initialize from msg, raising an error in case of problems"""
        self.msg = msg

        s = parsequopri(msg.get('Subject', ''))
        self.subject, self.title, self.index, self.count = parsesubject(s)

        # Extract threading information
        self.id = msg.get('Message-ID')
        if not self.id:
            raise parseerror(_('no message id'))
        self.parentid = msg.get('In-Reply-to')
        if not self.parentid:
            self.parentid = msg.get_all('References', [None])[-1]

    def __cmp__(self, other):
        """Compare by Message-ID"""
        return cmp(self.id, other.id)

    def __hash__(self):
        """Hash on Message-ID"""
        return hash(self.id)

    def date(self):
        """Return the header date as epoch seconds"""
        d = email.utils.parsedate(self.msg['Date'])
        if d is None:
            d = tuple([0 for i in range(9)])
        return time.mktime(d)

    def sender(self):
        """Return the header From value"""
        return self.msg.get('From')

def getpatchmessages(paths):
    """Yield all patchbomb messages in the specified mboxes"""
    for path in paths:
        mbox = mailbox.mbox(path, create=False)
        for m in mbox:
            try:
                msg = patchmessage(m)
            except parseerror:
                continue
            yield msg

def clustermessages(msgs):
    """Yield sublists of msgs eligible as message groups, looking at their
    author, date locality and items count.
    """
    def cmpdate(a, b):
        return cmp(a.date(), b.date())

    def findclusters(msgs):
        """If msgs has as many messages as the first one expects to have,
        return it. Otherwise, split the list at the widest time gap and recurse.
        """
        if len(msgs) == msgs[0].count:
            yield msgs
        elif len(msgs) < 2:
            return
        else:
            mincount = min([m.count for m in msgs])
            if mincount > len(msgs):
                return
            msgs.sort(cmpdate)
            split = max([(msgs[i].date() - msgs[i-1].date(), i)
                         for i in range(1, len(msgs))])[1]
            for remaining in (msgs[:split], msgs[split:]):
                for c in findclusters(remaining):
                    yield c

    senders = {}
    for m in msgs:
        senders.setdefault(m.sender(), []).append(m)
    for groups in senders.itervalues():
        for c in findclusters(groups):
            yield c

def getgroups(patchmessages, datefn, orphans=False):
    """Yield groups found in patchmessages if accepted by datefn.
    Each group is a tuple with intro message (or None) and patch list.
    If orphans is set then groups are created for orphans too."""
    def makegroup(msgs):
        """Return msgs sorted by index if they are a complete sequence"""
        msgs = [(m.index, m) for m in msgs]
        msgs.sort()
        indexes = [m[0] for m in msgs]
        if indexes != list(range(len(msgs))):
            return None
        msgs = [m[1] for m in msgs]
        return msgs

    pendings = {}
    orphaneds = {}
    for m in patchmessages:
        if not datefn(m.date()):
            continue
        if m.count == 1:
            yield None, [m]
            continue
        msgid = m.parentid
        if msgid is None:
            orphaneds[m.id] = m
        if m.index == 0:
            msgid = m.id
        if not msgid:
            continue
        pendings.setdefault(msgid, []).append(m)
        msgs = pendings[msgid]
        if len(msgs) != m.count:
            continue
        msgs = makegroup(msgs)
        if msgs is None:
            continue
        for m in msgs:
            if m.id in orphaneds:
                del orphaneds[m.id]
        del pendings[msgid]
        yield msgs[0], msgs[1:]

    # Try to find more groups using sender and date locality
    for msgs in pendings.itervalues():
        for m in msgs:
            orphaneds[m.id] = m
    for msgs in clustermessages(orphaneds.values()):
        msgs = makegroup(msgs)
        if msgs is None:
            continue
        for m in msgs:
            del orphaneds[m.id]
        yield msgs[0], msgs[1:]

    if not orphans:
        return
    # Return orphaned messages as standalone groups
    for m in orphaneds.values():
        if m.count > 0 and m.index == 0:
            continue
        m.index, m.count = 0, 1
        yield None, [m]

def makepatchname(existing, title):
    """Return a suitable filename for title, adding a suffix to make
    it unique in the existing list"""
    namebase = title.lower()
    namebase = re.sub('\s', '_', namebase)
    namebase = re.sub('\W', '', namebase)
    name = namebase
    for i in xrange(1, 100):
        if name not in existing:
            return name
        name = '%s__%d' % (namebase, i)
    raise util.Abort(_("can't make patch name for %s") % namebase)

re_ispatch = re.compile(r'^(# HG|diff\s)', re.M)

def getpayload(msg):
    if msg.is_multipart():
        for m in msg.get_payload():
            s = getpayload(m)
            if s is not None:
                return s
    else:
        s = msg.get_payload()
        if re_ispatch.search(s):
            return s
    return None

def importpatch(ui, repo, patchname, msg):
    """qimport the patch found in msg as patchname"""
    try:
        mq = extensions.find('mq')
    except KeyError:
        raise util.Abort(_("'mq' extension not loaded"))

    s = getpayload(msg)
    if s is None:
        raise util.Abort(_("cannot find patch in message content"))

    s = s.replace('\r\n', '\n')
    tmpfd, tmppath = tempfile.mkstemp(prefix='hg-mbox-')
    try:
        try:
            fp = os.fdopen(tmpfd, 'wb')
            fp.write(s)
            fp.close()
            tmpfd = None
        except IOError:
            if tmpfd:
                os.close(tmpfd)
            raise

        mq.qimport(ui, repo, tmppath, name=patchname, existing=False,
                   force=False, rev=[], git=False)
    finally:
        os.remove(tmppath)

def importpatches(ui, repo, groups):
    """qimport patches in groups in order"""
    imported = []
    # Patches are enumerated backward because qimport prepends them.
    # Groups are enumerated normally because they are already sorted
    # by descending dates, and we want old groups first.
    for patches in groups:
        for p in patches[::-1]:
            name = makepatchname(repo.mq.series, p.title)
            importpatch(ui, repo, name, p.msg)
            imported.append(name)
    ui.status(_('%d patches imported\n') % len(imported))

def makematcher(patterns):
    """Return a matcher function match((intro, patches)) returning True if
    the patch group matches the set of patterns.
    """
    if not patterns:
        return util.always

    regexps = [re.compile(p, re.I) for p in patterns]

    def match(group):
        intro, patches = group
        text = []
        if intro:
            text.append(intro.title)
        text += [p.title for p in patches]
        text = '\n'.join(text)
        for r in regexps:
            if not r.search(text):
                return False
        return True

    return match

def removeduplicates(groups):
    """Remove group duplicates, preserving input order."""
    seen = {}
    kept = []
    for intro, patches in groups:
        p = intro or patches[0]
        if (p.title, p.sender()) in seen:
            continue
        seen[(p.title, p.sender())] = 1
        kept.append((intro, patches))
    return kept

def mimport(ui, repo, *patterns, **opts):
    """qimport patches from mailboxes

    You will be prompted for whether to qimport items from every patch
    group found in configured mailboxes (see 'hg help mbox' for
    details). If patterns are passed they will be used to filter out
    patch groups not matching either of them. Group duplicates (based
    on group or first patch title and sender) are ignored too. For
    each query, the following responses are possible:

    n - skip this patch group
    y - qimport this patch group

    d - done, import selected patches and quit
    q - quit, importing nothing

    ? - display help
    """
    if opts['mbox']:
        paths = [opts['mbox']]
    else:
        paths = ui.config('mbox', 'paths', '').split(os.pathsep)
    paths = [p.strip() for p in paths if p]
    if not paths:
        raise util.Abort(_('no mailbox path configured'))
    patchmessages = getpatchmessages(paths)

    matcher = makematcher(patterns)
    selecteds = []
    stop = False

    datefn = util.always
    if opts.get('date'):
        datefn = util.matchdate(opts.get('date'))
    orphans = opts.get('all')
    groups = filter(matcher, getgroups(patchmessages, datefn, orphans))
    def cmpgroup(a, b):
        return -cmp(a[1][0].date(), b[1][0].date())
    groups.sort(cmpgroup)
    groups = removeduplicates(groups)

    for intro, patches in groups:
        if intro:
            ui.status('%s\n' % intro.subject)
            for p in patches:
                ui.status('    %s\n' % p.subject)
        else:
            ui.status('%s\n' % patches[0].subject)

        while 1:
            allowed = _('[Nydq?]')
            choices = [_('&No'), _('&Yes'), _('&Done'), _('&Quit'), _('&?')]
            r = ui.promptchoice(_('import this group? %s ') % allowed, choices)
            if r == 4:
                doc = gettext(mimport.__doc__)
                c = doc.find(_('n - skip this patch group'))
                for l in doc[c:].splitlines():
                    if l:
                        ui.write(l.strip(), '\n')
                continue
            elif r == 1:
                selecteds.append(patches)
            elif r == 2:
                stop = True
            elif r == 3:
                raise util.Abort(_('user quit'))
            break

        if stop:
            break
        ui.status('\n')

    importpatches(ui, repo, selecteds)

cmdtable = {}

def extsetup():
    try:
        mq = extensions.find('mq')
    except KeyError:
        return

    cmdtable['mimport'] = (
        mimport,
        [('a', 'all', False, _('show all patches, including orphaned ones')),
         ('d', 'date', '', _('show patches matching date spec')),
         ('m', 'mbox', '', _('path to an mbox to parse')),
         ],
        _('hg mimport PATTERN...'))
