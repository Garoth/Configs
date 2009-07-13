#!/usr/bin/env python
import sys

class Commit:
        def __init__(self, hash, message):
                self.hash = hash
                self.message = message

        def formatMessage(self):
                text = self.message.replace("\n", "\n   ")
                text = text.strip(" ")
                text = "-> " + text
                return text

        def formatHash(self):
                hash = "["  + self.hash[0:10] + "]"
                return hash

if __name__ == "__main__":
        commits = []

        # STEP 1: Create the commit objects
        file = open(sys.argv[1])
        hash = None
        message = None
        author = None
        while True:
                line = file.readline()
                if len(line) == 0:
                        break

                if line.startswith("commit"):
                        # Save last if we have one
                        if hash != None:
                                hash = hash.strip()
                                message = message.strip()
                                commits.append(Commit(hash, message))
                                hash = None
                                message = None

                        hash = line.split(" ")[1]
                        # skip this message if author ain't me
                        author = line.split(" ", 1)[1]
                        # skip Date, blank line
                        file.readline()
                        file.readline()
                else:
                        # Read the message
                        if not message:
                                message = line.strip(" ")
                        else:
                                message += line.strip(" ")
        # And the last one...
        if hash and ("Andrei" in author):
                hash = hash.strip()
                message = message.strip()
                commits.append(Commit(hash, message))

        # STEP 2: Do some formatting
        finalOutput = \
"""Build Manager Coding
====================
Code Change Summary
-------------------
"""
        for commit in commits:
                finalOutput += commit.formatMessage() + "\n"

        finalOutput += """
Commits Covered
---------------
"""

        hashes = []
        for commit in commits:
                hashes.append(commit.formatHash())

        somehashes = []
        for hash in hashes:
                if len(somehashes) < 5:
                        somehashes.append(hash)
                else:
                        finalOutput += ", ".join(somehashes) + "\n"
                        somehashes = []
                        somehashes.append(hash)
        # Do leftovers
        if somehashes:
                finalOutput += ", ".join(somehashes) + "\n"

        print finalOutput,
