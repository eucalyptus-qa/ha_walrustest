#!/usr/bin/python

import getopt
import sys
from subprocess import * 
import time
import os
import re

#process opts
class WalrusConfig(object):

    def __init__(self):
        self.hosts = []
        self.ips = ["WS0", "WS1"]

    def get_walrii_ips(self, filepath):
        data = open(filepath).readlines()
        for line in data:
            toks = re.split('\s+', line)
            if "WS" in line and "MASTER" in line:
                self.ips[0] = toks[2];
#                self.ips[0]=line[line.find("WS ") + 5:line.find("\t")]
            if "WS" in line and "SLAVE" in line:
                self.ips[1] = toks[2];
#                self.ips[1]=line[line.find("WS ") + 5:line.find("\t")]
          
    def get_hosts_from_ips(self):
        for ip in self.ips:
            cmd = ['ssh', 'root@%s' % ip, 'hostname']
            host_string = Popen(cmd, stdout=PIPE, stderr=PIPE).communicate()
            self.hosts.append(host_string[0].split('\n')[0])

#configure this thing
config = WalrusConfig()
config.get_walrii_ips("../status/current_roles")
#0 is master, 1 is slave

try:
    slave=int(sys.argv[1])
except Exception:
    print "Invalid input"
    exit(1)
if slave > 0:
    s3_url = "http://%s:8773/services/Walrus" % config.ips[1]
else:
    s3_url = "http://%s:8773/services/Walrus" % config.ips[0]
print s3_url
