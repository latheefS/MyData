#*****************************************************************************
#**
#**                 Copyright (c) 2022 Version 1
#**
#**                           Millennium House,
#**                           Millennium Walkway,
#**                           Dublin 1
#**                           D01 F5P8
#**
#**                           All rights reserved.
#**
#*****************************************************************************
#**
#**
#** VERSION   :  2.0
#**
#** AUTHORS   :  Joe Lalor
#**
#** PURPOSE   :  Installation control shell
#**
#** NOTES     :	 See Maximise_Installation_Guide.docx
#**
#******************************************************************************
#!/bin/sh

home=$(pwd)

sys_pw=""
echo
echo "Welcome to Version 1's Maximise DM Installation (Release 22.1)"
echo
read -p "Create XXMX schemas (Y/N)? (Y) " -r create_XXMX_schemas
echo

if [ -z "$create_XXMX_schemas" ]
then
	create_XXMX_schemas="Y"
fi

create_XXMX_schemas=$(tr '[a-z]' '[A-Z]' <<< $create_XXMX_schemas)

if [ "$create_XXMX_schemas" == "Y" ]
then
	read -p "Enter the SYS password for MXDM_PDB1 " -r -s sys_pw
	echo
	stg_pw=""
	until [ ! $stg_pw = "" ]
	do
		echo
		echo "The Maximise schema passwords must consist of at least 9 characters, 2 numerals, 2 uppercase, 2 lowercase and 2 special chars (no quote marks)"
		echo
		read -p "Choose STG SCHEMA password " -r stg_pw
		echo
	done
	echo "XFM and CORE passwords will default to the STG password if left blank"
	echo
	read -p "Choose XFM SCHEMA password ($stg_pw) " -r xfm_pw
	echo
	if [ -z "$xfm_pw" ]
	then
		xfm_pw=$stg_pw
	fi
	read -p "Choose CORE SCHEMA password ($stg_pw) " -r core_pw
	echo
	if [ -z "$core_pw" ]
	then
		core_pw=$stg_pw
	fi
	sudo -u oracle -i sqlplus sys/$sys_pw@MXDM_PDB1 as sysdba @/$home/CORE/DBObjects/xxmx_schema_creation.sql $stg_pw $xfm_pw $core_pw $home
	echo
	grep 'ORA-\|Error\|SP2-\|PLS-' $home/schema_creation.log
	grep 'successfully created' $home/schema_creation.log
	echo
fi

read -p "Create DB link to EBS database (Y/N)? (Y) " -r create_DB_link

if [ -z "$create_DB_link" ]
then
	create_DB_link="Y"
fi

create_DB_link=$(tr '[a-z]' '[A-Z]' <<< $create_DB_link)

if [ "$create_DB_link" == "Y" ]
then
	if [ "$sys_pw" == "" ]
	then
		echo
		read -p "Enter the SYS password for MXDM_PDB1 " -r -s sys_pw
		echo
	fi
	echo
	read -p "Enter the APPS password for EBS database " -r -s apps_pw
	echo
	echo
	read -p "Enter the EBS database connection string (service:port/host) " -r ebs_conn
	echo
	sudo -u oracle -i sqlplus sys/$sys_pw@MXDM_PDB1 as sysdba @/$home/CORE/DBObjects/xxmx_dblink.sql $apps_pw $ebs_conn $home
	echo
	grep 'ORA-\|Error\|SP2-\|PLS-' $home/dblink.log
	grep 'successfully created' $home/dblink.log
fi

echo

if [ ! "$create_XXMX_schemas" == "Y" ]
then
	stg_pw=""
	until [ ! $stg_pw = "" ]
	do
		read -p "Enter STG SCHEMA password " -r stg_pw
		echo
	done
	read -p "Enter XFM SCHEMA password ($stg_pw) " -r xfm_pw
	echo
	if [ -z "$xfm_pw" ]
	then
		xfm_pw=$stg_pw
	fi
	read -p "Enter CORE SCHEMA password ($stg_pw) " -r core_pw
	echo
	if [ -z "$core_pw" ]
	then
		core_pw=$stg_pw
	fi
fi

#--=================================================================================================
#--== MXDM 1.0 STG Tables Creation Script
#--=================================================================================================

AP_scripts="$home/AP/Invoices/Packages"
AR_scripts="$home/AP/Invoices/Packages"
BEN_scripts="$home/BEN/Invoices/Packages"
FA_scripts="$home/FA/Invoices/Packages"
HCM_scripts="$home/HCM/Invoices/Packages"
INV_scripts="$home/INV/Invoices/Packages"
LRN_scripts="$home/LRN/Invoices/Packages"
PA_scripts="$home/PA/Invoices/Packages"
PAY_scripts="$home/PAY/Invoices/Packages"
PO_scripts="$home/PO/Invoices/Packages"

sudo -u oracle -i sqlplus xxmx_stg/$stg_pw@MXDM_PDB1 @/$home/CORE/DBObjects/xxmx_stg_master.sql $home
echo
grep 'ORA-\|Error\|SP2-\|PLS-' $home/stg.log
#$migrate_FIN $migrate_HCM $migrate_PAY

echo
sudo -u oracle -i sqlplus xxmx_xfm/$xfm_pw@MXDM_PDB1 @/$home/CORE/DBObjects/xxmx_xfm_master.sql $home
echo
grep 'ORA-\|Error\|SP2-\|PLS-' $home/xfm.log

echo
sudo -u oracle -i sqlplus xxmx_core/$core_pw@MXDM_PDB1 @/$home/CORE/DBObjects/xxmx_core_oic_dbi.sql $home
sudo -u oracle -i sqlplus xxmx_core/$core_pw@MXDM_PDB1 @/$home/CORE/DBObjects/xxmx_core_master.sql $home
echo
grep 'ORA-\|SP2-\|PLS-' $home/core.log

echo "-------------------------------------------------------"
echo
echo "Which EBS modules will be migrated?"
echo
read -p "FIN (Y/N)? (Y) " -r migrate_FIN
echo
read -p "HCM (Y/N)? (Y) " -r migrate_HCM
echo
read -p "PAY (Y/N)? (Y) " -r migrate_PAY
echo
read -p "Maximise Custom Extensions and Core OIC Objects (Y/N)? (Y) " -r migrate_OIC
echo
echo "-------------------------------------------------------"
echo

if [ -z "$migrate_FIN" ]
then
	migrate_FIN="Y"
fi

migrate_FIN=$(tr '[a-z]' '[A-Z]' <<< $migrate_FIN)

if [ "$migrate_FIN" == "Y" ]
then
	sudo -u oracle -i sqlplus xxmx_core/$core_pw@MXDM_PDB1 @/$home/CORE/DBObjects/xxmx_master_fin_core.sql $home
	echo
	echo "Financial Core Scripts successfully Installed"
	grep 'ORA-\|SP2-\|PLS-' $home/fin.log
fi
#--=================================================================================================
#--== MXDM 1.0 HCM PLSQL Script
#--=================================================================================================

if [ -z "$migrate_HCM" ]
then
	migrate_HCM="Y"
fi

migrate_HCM=$(tr '[a-z]' '[A-Z]' <<< $migrate_HCM)

if [ "$migrate_HCM" == "Y" ]
then
	sudo -u oracle -i sqlplus xxmx_core/$core_pw@MXDM_PDB1 @/$home/CORE/DBObjects/xxmx_master_hcm_core.sql $home
	grep 'ORA-\|SP2-\|PLS-' $home/hcmcore.log
#sudo -u oracle -i sqlplus xxmx_stg/$stg_pw@MXDM_PDB1 @/$home/RECRUIT/DBObjects/xxmx_master_hcm_stg.sql $home
#grep 'ORA-\|SP2-\|PLS-' $home/hcmstg.log
#sudo -u #oracle -i sqlplus xxmx_xfm/$xfm_pw@MXDM_PDB1 @/$home/HCM/DBObjects/xxmx_master_hcm_xfm.sql $home
#grep 'ORA-\|SP2-\|PLS-' $home/hcmxfm.log
	echo
	echo "HCM successfully Installed"
fi

sudo -u oracle -i sqlplus xxmx_core/$core_pw@MXDM_PDB1 @/$home/CORE/DBObjects/xxmx_master_xfm_dd.sql $home
grep 'ORA-\|SP2-\|PLS-' $home/masterxfmdd.log
sudo -u oracle -i sqlplus xxmx_core/$core_pw@MXDM_PDB1 @/$home/CORE/DBObjects/xxmx_master_stg_dd.sql $home
grep 'ORA-\|SP2-\|PLS-' $home/masterstgdd.log

sudo -u oracle -i sqlplus xxmx_core/$core_pw@MXDM_PDB1 @/$home/CORE/DBObjects/xxmx_update_xfm_dd.sql $home
grep 'ORA-\|SP2-\|PLS-' $home/updatexfmdd.log

echo
echo "DataDictionary successfully Installed"

if [ -z "$migrate_PAY" ]
then
	migrate_PAY="Y"
fi

migrate_PAY=$(tr '[a-z]' '[A-Z]' <<< $migrate_PAY)

#--========================================================================================================
#--== MXDM 1.0 PAYROLL CORE Script
#--========================================================================================================
if [ "$migrate_PAY" == "Y" ]
then
#	sudo -u oracle -i sqlplus xxmx_core/$core_pw@MXDM_PDB1 @/$home/CORE/DBObjects/xxmx_master_pay_core.sql 
	echo
	echo "Payroll Core Scripts successfully Installed"
fi

#--=======================================================================================================
#--== MXDM 22.1 Maximise Custom Extensions and core OIC Enhancements - PLSQL 
#--=======================================================================================================

if [ -z "$migrate_OIC" ]
then
	migrate_OIC="Y"
fi

migrate_OIC=$(tr '[a-z]' '[A-Z]' <<< $migrate_OIC)

if [ "$migrate_OIC" == "Y" ]
then
	sudo -u oracle -i sqlplus xxmx_core/$core_pw@MXDM_PDB1 @/$home/EXTENSION/xxmx_core_oic.sql $home
	grep 'ORA-\|SP2-\|PLS-' $home/oiccore.log
	echo
	echo "Maximise Custom Extensions and Core OIC Objects successfully Installed"
fi

#--=======================================================================================================
#--== MXDM Custom PLSQL Scripts
#--=======================================================================================================
./xxmx_custom.sh "$core_pw" "$stg_pw" "$xfm_pw"

#--========================================================================================================
#--== MXDM Installation Completed
#--========================================================================================================
echo
echo "Maximise 2.0 successfully Installed"
echo

