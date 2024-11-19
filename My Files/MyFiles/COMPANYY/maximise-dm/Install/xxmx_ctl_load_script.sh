#!/bin/sh

echo ""
echo ""
echo "*******************Provide Input Details******************"
echo ""
echo "Please provide the path for dat file: " 
read datafilepath
echo ""
echo "Please provide the path for ctl file: "
read loadfilepath
echo ""
echo "Please provide the path for log and bad files: " 
read logfilepath
echo ""
echo "Please provide archive path for ctl:"
read archivepath
echo ""
echo "Provide Login Details: "
read login
echo ""
echo "***********************End of Input*********************"



echo " Operation Starts" 

cd $loadfilepath
for file in XXMX_HCM*.ctl;
do 

echo $file 
echo ""
echo "********************CTL File $File***********************"
filename=$(echo "$file"| cut -f 1 -d '.')
echo $filename 

# Sqlloader commands for each of the CTL File in the loop.

datafile=$datafilepath/$filename.dat
echo $datafile
echo "Check if $datafile exists"

if [[ -f $datafile ]]; then

    
    echo "$datafile exists: SQLLDR Operation Started for File "
    
    sqlldr userid=$login  control=$loadfilepath/$filename.ctl  data=$datafile

    if(sqlldr userid=$login  control=$loadfilepath/$filename.ctl  data=$datafilepath/$filename.dat)
     then
        echo "Import successful"
	echo ""
    else
	echo "Import failed"
	echo ""
    fi

   echo  $loadfilepath/$filename.ctl
   echo  $datafilepath/$filename.dat
   echo "Move the files to archive folder"
   mv $loadfilepath/$filename.* $archivepath
   mv $datafilepath/$filename.* $archivepath

else
    echo "$datafile is missing : Skipped Loader Operation"
fi
echo "******************CTL Operation Completed****************"
done
