#!/usr/bin/env python
#
# Run this script to generate the mbox test sample
#
import email, mailbox, os

# Fill the test mailbox
os.remove('test.mbx')
mbox = mailbox.mbox('test.mbx')

mbox.add(email.message_from_file(file('msg1')))

# Add a different patch with the same name from the same author
# It should hide the previous one
mbox.add(email.message_from_file(file('msg2')))

# Another a patch with a different title
mbox.add(email.message_from_file(file('msg3')))

mbox.close()
