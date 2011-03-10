#! /usr/bin/python

from optparse import OptionParser
import time
import socket
NAGIOS_FAIL = 2
NAGIOS_WARN = 1
NAGIOS_UNKNOWN = 3
NAGIOS_OK = 0

def parse_options():
    required_options = ('host', 'critical', 'warning')
    parser = OptionParser(usage="usage: %prog -h host -c crit -w warn [other options]")
    parser.add_option("-H", "--host", help="The HOST to check",
            metavar="HOST", dest="host")
    parser.add_option("-w", "--warning", help="The WARNING response time threshold",
            metavar="WARNING", dest="warning", type=int)
    parser.add_option("-c", "--critical", help="The CRITICAL response time threshold",
            metavar="CRITICAL", dest="critical", type=int)
    parser.add_option("-p", "--port", help="The Memcache PORT on the host",
            metavar="PORT", dest="port", default=11211, type=int)
    (options, args) = parser.parse_args()
    for opt in required_options:
        if not getattr(options, opt):
            parser.error('Required argument %s missing' % opt)
    return options

def check_memcache(options):
    timestamp = time.time()
    mc = memcache(host=options.host, port=options.port, timeout=options.critical)
    stats = mc.stats()
    conn_time = time.time() - timestamp
    if conn_time > options.warning:
        die(NAGIOS_WARN, "Connection time was %d" % conn_time)
    if conn_time > options.critical:
        die(NAGIOS_FAIL, "Connection time was %d" % conn_time)

    status = "OK | %s\n" % [s for s in  stats if s.startswith('total_items')][0]
    status += ("|" + "\n".join(stats))
    die(NAGIOS_OK, status)

def die(err_code, msg):
    print msg + "\n"
    exit(err_code)

def try_or_die(func):
    def try_func(self, *arg):
        try:
            resp = func(self, *arg)
        except socket.timeout as timeout_err:
            die(NAGIOS_FAIL, "Timeout while trying to connect to %s at port %d" % (self.host, self.port))
        except (socket.herror, socket.gaierror) as host_error:
            die(NAGIOS_UNKNOWN, "Hostname error? %s" % host_error)
        except Exception as e:
            die(NAGIOS_UNKNOWN, "Unknown error occurred: %s" % e)
        return resp
    return try_func


class memcache(object):
    def __init__(self, host, port, timeout=30):
        self.port = port
        self.host = host
        self.timeout = timeout
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.settimeout(timeout)
        self.connect_socket(host, port)
        if type(self.sock) == type(None):
            die(NAGIOS_FAIL, "Failed to connect")

    @try_or_die
    def connect_socket(self, host, port):
        self.sock.connect((host, port))

    @try_or_die
    def stats(self):
        self.sock.sendall("stats\r\n")
        resp = self.sock.recv(4096)
        resp = resp.replace('STAT ', '').splitlines()
        resp.remove('END')
        resp = map(lambda s: s.replace(' ', "="), resp)
        return resp

if __name__ == "__main__":
    options = parse_options()
    check_memcache(options)
