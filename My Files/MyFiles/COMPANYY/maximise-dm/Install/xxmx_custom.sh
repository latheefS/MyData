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
#** PURPOSE   :  Installation cutomisation shell
#**
#** NOTES     :	 Write your custom shell commands, e.g., run xxmx_custom.sql
#**				 See Maximise_Installation_Guide.docx
#**
#******************************************************************************
#!/bin/sh
core_pw=$1
stg_pw=$2
xfm_pw=$3
home=$(pwd)

echo
echo "Maximise 2.0 Customisation"
echo
sudo -u oracle -i sqlplus xxmx_stg/$stg_pw@MXDM_PDB1 @/$home/xxmx_custom.sql $home
echo
grep 'ORA-\|Error\|SP2-\|PLS-' $home/custom.log
echo
echo "Maximise 2.0 customisation complete"
echo

