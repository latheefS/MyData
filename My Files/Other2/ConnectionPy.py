import oracledb

connection=oracledb.connect(user="XXMX_CORE", password="OraclPwd1234",host="130.61.213.63", port=1521, service_name="MXDM_PDB1.apexfra1red.apexvcn.oraclevcn.com")
print(connection.version)