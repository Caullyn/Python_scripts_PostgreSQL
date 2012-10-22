#!/usr/bin/env python
from optparse import OptionParser
import paramiko
import time
import datetime

use = "Usage: %prog master slave"
parser = OptionParser(usage = use)
options, args = parser.parse_args()
def CalculateNumericalOffset(filename):

        pieces = filename.strip().split('/')
        # First part is logid, second part is record offset
        return (4278190080 * int(pieces[0], 16)) + int(pieces[1], 16)

def monitor_lag():
        stdout_master = []
	stderr_master = []
	stdout_slave = []
	stderr_slave = []
	master_pos = ''
	slave_pos = ''

        print datetime.datetime.now()
	mstr = "{0}".format(args[0])
	slv = "{0}".format(args[1])
	master = paramiko.Transport((mstr,22))
	master.connect(username='postgres', password='ytrdS#3')
	session = master.open_channel(kind='session')
	print "Connected to master: {m}".format(m=args[0])
	session.exec_command("psql -tc 'select pg_current_xlog_location();'")
	time.sleep(1)
	while True:
    		if session.recv_ready():
        		stdout_master.append(session.recv(4096))
    		if session.recv_stderr_ready():
        		stderr_master.append(session.recv_stderr(4096))
    		if session.exit_status_ready():
        		break
	master_pos = ''.join(stdout_master)
	
	print 'Master current xlog location is {0}'.format(master_pos)	
	session.close()
	master.close()
	slave = paramiko.Transport((slv,22))
	slave.connect(username='postgres', password='ytrdS#3')
	session = slave.open_channel(kind='session')
	print "Connected to slave: {s}".format(s=args[1])
        session.exec_command("psql -tc 'select pg_last_xlog_receive_location(), pg_last_xlog_replay_location();'")
	time.sleep(1)
        while True:
                if session.recv_ready():
                        stdout_slave.append(session.recv(4096))
                if session.recv_stderr_ready():
                        stderr_slave.append(session.recv_stderr(4096))
                if session.exit_status_ready():
                        break
	slave_pos = ''.join(stdout_slave)
	print 'Slave last xlog receive / replay locations are {0}'.format(slave_pos.replace('|','/'))
        session.close()
        slave.close()
	master_num = CalculateNumericalOffset(master_pos)
	slave_nums = slave_pos.split('|')
	slave_receive = master_num - CalculateNumericalOffset(slave_nums[0])
	slave_replay = master_num - CalculateNumericalOffset(slave_nums[1])
	if slave_receive > 100:
		print "ALERT: Slave receive delay is high: {0} kb".format(slave_receive)
	else:
		print "Slave receive delay is: {0} kb".format(slave_receive)

	if slave_replay > 100:
		print "ALERT: Slave replay delay is high: {0} kb".format(slave_replay)
	else:
		print "Slave replay delay is: {0} kb".format(slave_replay)
monitor_lag()
