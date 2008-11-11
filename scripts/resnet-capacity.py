#!/usr/bin/python

import re
import urllib

reznetQuery = "http://noc.uwaterloo.ca/cn/scripts/queryUse"
pattern = re.compile(".*gold\"\>(.?[0-9]+\.?[0-9]*MB).*")
cantopen = False

try:
	url = urllib.urlopen(reznetQuery)
except:
	url = "can't open"
	cantopen = True

line = "-"
match = "no match yet"

while len (line) != 0 and cantopen == False:
	line = url.readline()
	if type(pattern.match(line,0)) == type(re.compile("a").match("a")):
		match = pattern.match(line)

if cantopen == True:
	print "Resnet Error -- No Connection"
elif match ==  "no match yet":
	print "Resnet Error -- Capacity Not Found On Page:\n" + reznetQuery
else:
	text = match.groups()[0]
	print text
