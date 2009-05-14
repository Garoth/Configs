#!/usr/bin/python
import xml.dom.minidom as xml

f = open("/home/garoth/.todo")
dom = xml.parse(f)
notes = dom.getElementsByTagName("note")
for note in notes:
        print(note.attributes["priority"].firstChild.data) + " | ",
        print(note.attributes["time"].firstChild.data) + " | ",
        if note.hasAttribute("done"):
                print(note.attributes["done"].firstChild.data)
        else:
                print("")
        print(note.firstChild.data.strip())
