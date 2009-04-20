#!/usr/bin/python

import urllib
import getpass

import socket
import fcntl
import struct

def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])

def decrypt_pass(filename):
    file = open(filename)
    passwd = ""
    for line in file:
        passwd += chr(int(line))
    return passwd

ip = get_ip_address('wlan0')
#HERE
mac = ''
url = 'https://cn-wc.uwaterloo.ca/auth/index.html/u'
referer = "https://cn-wc.uwaterloo.ca/upload/custom/uw-portal/index.html?cmd=login&mac=%s&ip=%s&essid=uw-wireless" % (mac, ip)

"""
    The post data
"""
mydata = dict()
mydata['directory'] = ''
mydata['screenwidth'] = '1280'
mydata['screenheight'] = '800'
mydata['mode'] = 'Connect'
#HERE
mydata['user'] = 'aapachin'
mydata['password'] = decrypt_pass("/etc/network.d/uw-wireless-pass")

"""
    Headers
"""
heads = {
     'Host': 'cn-wc.uwaterloo.ca'
    ,'User-Agent': 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv\': \'1.9.0.5) Gecko/2008120121 Firefox/3.0.5'
    ,'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    ,'Accept-Language': 'en-us,en;q=0.5'
    ,'Accept-Encoding': 'gzip,deflate'
    ,'Accept-Charset': 'UTF-8,*'
    ,'Keep-Alive': '300'
    ,'Connection': 'keep-alive'
    ,'Referer': referer
    ,'Content-Type': 'application/x-www-form-urlencoded'
}

enddata = urllib.urlencode(mydata)

resp = urllib.urlopen(url, enddata, heads)

print resp.read()
