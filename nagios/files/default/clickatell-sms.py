#! /usr/bin/env python
import urllib2, urllib
import re
from optparse import OptionParser

required_options = ('api_id', 'user', 'password')
parser = OptionParser(usage="usage: %prog [options] phoneno message")
parser.add_option("-u", "--user", help="Your Clickatell USERNAME", metavar="USERNAME", dest="user")
parser.add_option("-k", "--key", help="Clickatell API ID KEY", metavar="KEY", dest="api_id")
parser.add_option("-p", "--password", help="Your Clickatell PASSWORD", metavar="PASSWORD", dest="password")
base_url = 'https://api.clickatell.com/http/sendmsg'
(options, args) = parser.parse_args()

if len(args) < 2: parser.error("Incorect number of arguments")
if not re.match('\+?[0-9]+', args[0]): parser.error("Invalid phone or pager number")
for opt in required_options:
    if not getattr(options, opt): parser.error('Required argument %s missing' % opt)

text = str.join(' ', args[1:])
phone = args[0]
params = urllib.urlencode({'api_id': options.api_id, 'user': options.user, 'password': options.password, 'to': phone, 'text': text})
response = urllib2.urlopen(base_url + '?' + params)
print response.read()
