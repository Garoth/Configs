#!/usr/bin/python
import xml.dom.minidom as xml

f = open("/home/garoth/.todo")
dom = xml.parse(f)
notes = dom.getElementsByTagName("note")
print(dom.attributes)
print(notes)
for note in notes:
        pass
