import psycopg2

try:
	con = psycopg2.connect("dbname='ehr_dev'")
	cur = con.cursor()
	cur.execute("select 'VACUUM ANALYZE '||c.relname||'; -- Frozen age '|| age(c.relfrozenxid) from pg_class c,pg_namespace n where c.relnamespace=n.oid and n.nspname='ehr_dev' and c.relkind = 'r' and age(c.relfrozenxid)>150000000 order by age(c.relfrozenxid);")
	rows = cur.fetchall()
	for row in rows:
		print "   ", row[0]
catch:
	print 'cannot connect'