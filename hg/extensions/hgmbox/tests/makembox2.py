#!/usr/bin/env python
#
# Run this script to generate the mbox test sample
#
import email, mailbox, os

# Fill the test mailbox
if os.path.isfile('test2.mbx'):
    os.remove('test2.mbx')
mbox = mailbox.mbox('test2.mbx')

# Sequence of 3 parentless patches from the same author
mbox.add(email.message_from_file(file('msg2.0')))
mbox.add(email.message_from_file(file('msg2.1')))
mbox.add(email.message_from_file(file('msg2.2')))
# One patch among 3 from another author, same date as previous ones
mbox.add(email.message_from_file(file('msg2.3')))
# One standalone patch of the first author, coming later
mbox.add(email.message_from_file(file('msg2.4')))

mbox.close()
