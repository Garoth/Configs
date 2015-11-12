#!/usr/bin/env python
# Based on https://gist.github.com/tarruda/37f7a3e22996addf8921
"""Edit a file in the host nvim instance."""
import os
import sys

from neovim import attach

args = sys.argv[1:]
if not args:
    print "Usage: {} <filename> ...".format(sys.argv[0])
    sys.exit(1)

addr = os.environ.get("NVIM_LISTEN_ADDRESS", None)
if not addr:
    os.execvp('nvim', args)

nvim = attach("socket", path=addr)

def _setup():
    nvim.input('<c-\\><c-n>')  # exit terminal mode
    chid = nvim.channel_id
    nvim.command('augroup EDIT')
    nvim.command('au BufEnter <buffer> call rpcnotify({0}, "n")'.format(chid))
    nvim.command('au BufEnter <buffer> startinsert'.format(chid))
    nvim.command('augroup END')
    nvim.vars['files_to_edit'] = args
    for x in args:
        nvim.command("drop {}".format(os.path.abspath(x).replace(" ", "\\ ")))

def _exit(*args):
    nvim.vars['files_to_edit'] = None
    nvim.command('augroup EDIT')
    nvim.command('au!')
    nvim.command('augroup END')
    nvim.session.stop()

nvim.session.run(_exit, _exit, _setup)
