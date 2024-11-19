#!/bin/sh

home=$(pwd)

sys_pw=""
echo
echo "Welcome to Version 1's Maximise DM Installation Wrapper"
echo
read -p "Place the unwrapped code in a folder here called Install, i.e., /home/opc/Install - Return when ready " -r Ready
echo
echo "Start ..." | tee -a wrapper.log

rm -f CheckFiles.txt
rm -f WrapFiles.sh
rm -f WrapFiles.txt

ReplaceText() {

	FileName=$1

    Rewrite=0

	echo $FileName
	
	while IFS= read -r line
	do
        NewLine=$line
		line=${line,,}
		if [[ $line == *"@"* ]] && [[ $line != *"xxmx_custom"* ]]
		then
            if [[ $line == *".sql"* ]] || [[ $line == *".pks"* ]] || [[ $line == *".pkh"* ]] || [[ $line == *".pkb"* ]]
			then
				echo "$NewLine"
                NewLine="${NewLine/.sql/.sqlplb}"
                NewLine="${NewLine/.SQL/.sqlplb}"
                NewLine="${NewLine/.pks/.pksplb}"
                NewLine="${NewLine/.PKS/.pksplb}"
                NewLine="${NewLine/.pkh/.pkhplb}"
                NewLine="${NewLine/.PKH/.pkhplb}"
                NewLine="${NewLine/.pkb/.pkbplb}"
                NewLine="${NewLine/.PKB/.pkbplb}"
				echo "$NewLine"
                Rewrite=1
            fi
		fi
        echo "$NewLine" >>$FileName"tmp"	
	done < "$FileName"
    
    if [ $Rewrite == 1 ] 
	then
        rm "$FileName"
        mv "${FileName}tmp"	"$FileName"
    else
        rm -f "${FileName}tmp"	
    fi
}


WrapFolder() {

	Folder=$1

	for file in $Folder/*
	do

		if [ -d "$file" ]
		then
			WrapFolder $file
		else
			if [[ $file != *"xxmx_custom.sql"* ]] && [[ $file != *"xxmx_custom.sh"* ]]
			then
				FileType=${file#*.}
				FileType=${FileType^^}

                                ext=`basename $FileType`
                                ext="${ext##*.}" 
                                              
				#if [[ "$FileType" =~ ^(SQL|PKS|PKH|PKB|SH)$ ]]
				if [[ "$file" == *pkg* ]] ||  [[ "$FileType" =~ ^(PKS|PKH|PKB)$ ]]
				then
					ReplaceText $file
				fi
                # read all file with pkg string but exclude files with extension pkb, pks or pkh
				if [[ "$file" == *pkg* ]] && [[ ! ($ext == PKB || $ext == PKS || $ext == PKH) ]]
				then 
					sudo -u oracle -i wrap iname=$file oname=$file"plb"
					rm $file
				fi
                # only process files with extension pkb, pks or pkh
				if [[ "$FileType" =~ ^(PKS|PKH|PKB)$ ]]
				then
				        sudo -u oracle -i wrap iname=$file oname=$file"plb"
					rm $file
				fi
			fi
		fi
	done
}

all_pk_ext=`find . -name '*.pk?' ! -name '*.sql' | wc -l`
all_pkg=`find . -name '*pkg*' ! -name '*.pk?' | wc -l`

echo "Files to wrap : "`expr $all_pk_ext + $all_pkg` | tee -a wrapper.log


WrapFolder $home/Install/CORE | tee -a wrapper.log

all_plb_files=`find . -name '*plb' | wc -l` 
echo "Total files wrapped : "$all_plb_files | tee -a wrapper.log
echo "Check the wrapper.log file for errors"

#file="/home/opc/Joe/Install/xxmx_master_mxdm.sh"


exit $?
