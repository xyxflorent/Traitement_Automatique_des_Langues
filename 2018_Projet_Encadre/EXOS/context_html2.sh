#!/bin/bash
# bash
context_html()
{
	echo "<!DOCTYPE>" > $4
	echo "<html lan=\"en\">" >> $4
	echo "<head>" >> $4
	echo "<meta charset=\"UTF-8\"/><title>Projet de Mot</title>" >> $4
	echo "<style>" >> $4
	echo "span{color:Brown;}" >>$4
	echo "</style>" >> $4
	echo "</head>"  >> $4
	echo "<body>" >> $4

	echo -e "<p style=\"color:Green\">FILENAME: <span>$1</span></p>" >> $4
	echo -e "<p style=\"color:Green\">Encoding: <span>$2</span></p>" >> $4
	echo -e "<p style=\"color:Green\">Keyword_pattern: <span>$3</span></p>" >> $4
	echo -e "<p style=\"color:Green\">Output File: <span>$4</span></p>" >> $4
	echo -e "<hr/>" >> $4

	cat -n $1 | egrep --color -C 1 "est" > temp.txt

	cat temp.txt | while read line
	do
		if echo $line | egrep "est" &>/dev/null
		then
			echo -e "<p style=\"color:Red\">$line</p>" >> $4
		else
			echo -e "<p style=\"color:Blue\" font><i>$line</i></p>" >> $4
		fi
	done

	rm temp.txt
	echo "</body>" >> $4
	echo "</html>" >> $4
}

start=`date +%s`
context_html essai.txt UTF-8 est 2.html
end=`date +%s`
let time=$end-$start

echo $time
