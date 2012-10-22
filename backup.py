import datetime, commands

now = datetime.datetime.now()
print now

bakfilename = "/pgbackup/ehr_%(y)s%(mo)s%(d)s-%(h)s%(m)s%(s)s" % \
	{"y": now.year, "mo": now.month, "d": now.day, "h": now.hour, "m": now.minute, "s": now.second}

print commands.getstatusoutput('/usr/bin/pg_dump -Fc ehr_dev > %(b)s.gz' % {"b": bakfilename} )
print commands.getstatusoutput('/usr/bin/pg_dump -Fp ehr_dev > %(b)s.txt' % {"b": bakfilename} )