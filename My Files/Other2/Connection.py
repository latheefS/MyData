import oracledb

p_username = "XXMX_CORE"
p_password = "OraclPwd1234"
p_host = "130.61.213.63"
p_service = "MXDM_PDB1.apexfra1red.apexvcn.oraclevcn.com"
p_dns = "130.61.213.63/MXDM_PDB1.apexfra1red.apexvcn.oraclevcn.com"
p_port = "1521"

con = oracledb.connect(user=p_username, password=p_password, dsn=p_dns, port=p_port,disable_oob=True)

print("Successfully connected to the database")
print(con.is_healthy())
print(con.thin)
print(con.version)

cur = con.cursor()
cur.execute('select * from all_objects where rownum = 1')

for row in cur:
      print(row)


cur.close()
con.close()
