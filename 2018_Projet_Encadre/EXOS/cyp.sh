#!/bin/bash
# bash 2.sh ./TABLEAUX/2.html ./URLS
. ./PROGRAMMES/cyf.sh

parameter_check $1 $2 
write_html_head $1

counter_table=0
for file in `ls $2`
{
	let counter_table+=1

	counter_line=0
	for line in `cat $2/$file`
	{
		let counter_line+=1
		http_code=`get_http_code $line`

		if [[ $http_code -eq 200 ]]
		then
			get_encoding $line

			if [[ $encoding == "UTF-8" ]]
			then
				processing_utf-8 $1 
			else
				if [[ -n $encoding ]]
				then
					encoding=`encoding_verify`
					if [[ -n $encoding ]]
					then
						processing_other $1
					else
						processing_other2
					fi
				else
					processing_other2 $1 
				fi
			fi

		else
			processing_other2 $1
		fi
	}
	combine ./DUMP-TEXT ./DUMP-TEXT/TOTAL_TEXT.txt 
	combine ./CONTEXTES ./CONTEXTES/TOTAL_CONTEXTE.txt 
	write_html_conclusion $1
}
write_html_tail $1

