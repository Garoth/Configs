#!/usr/bin/python

#------------------------------------------------------------------------------
#                                DBus Checker 
#                              ~--------------~
#
# Original Author: Andrei "Garoth" Thorp <garoth@gmail.com>
# License: GPL 2 or higher
#------------------------------------------------------------------------------
import dbus
import sys

try : 
	dbus.SessionBus()
	print "Session Bus Found"
	sys.exit(0)
except dbus.exceptions.DBusException :
	print "Session Bus Missing"
	sys.exit(1)

