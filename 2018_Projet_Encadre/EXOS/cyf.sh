#!/bin/bash
# bash 1.sh

parameter_check()
{
	if [[ $# -ne 2 ]]
	then
		echo "ParamError: only $# file received!"
		exit
	else
		echo "Processing..."
	fi
}


write_html_head() # parameter: html file
{
	echo "<!DOCTYPE>" > $1
	echo "<html lan=\"en\">" >> $1
	echo "<head><meta charset=\"UTF-8\"/><title>Projet de Mot</title></head>"  >> $1
	echo "<body>" >> $1
	echo "<table border=\"1\">" >> $1
	echo "<tr><th>ID</th><th>CODE_URL</th><th>LANG</th><th>WEB_LINKS</th><th>WEB_PAGE</th><th>ENCODING</th><th>DUMP-TEXT</th><th>CONTEXTE</th><th>CONTEXTE_HTML</th><th>BIGRAMS</th><th>FREQ_KEYWORD</th></tr>" >>$1
}

write_html_tail() # parameter: html file
{
	echo "</table>" >> $1
	echo "</body>" >> $1
	echo "</html>" >> $1
}

get_http_code()
{
	curl -o temp.txt -w "%{http_code}" $1
}

get_encoding() 
{
	encoding1=`curl -I $1 | egrep "charset" | cut -d"=" -f2 | tr [[:lower:]] [[:upper:]] | tr -d "\r"`
	encoding2=`curl $1 | egrep -o -i "<meta\s.*charset[^>]+>" | egrep -o -i "charset.+" | cut -d"=" -f2 | tr -d "[/\">]" | tr "[a-z]" "[A-Z]" | tail -1 | tr -d " "`
	if [[ $encoding1 == $encoding2 ]]
	then
		encoding=$encoding1
	else
		if [[ -z $encoding1 ]]
		then
			encoding=$encoding2
		fi
	fi
}

encoding_verify()
{
	iconv -l | egrep -o $encoding | head -1
}

processing_utf-8() # parameter: html file
{
	lynx -dump -nolist --assume-charset="$encoding" --display-charset="$encoding" $line > ./DUMP-TEXT/$counter_table-$counter_line.txt
	curl -SL -o ./PAGES-ASPIREES/$counter_table-$counter_line.html $line

	egrep -C 1 -i "individualisme|个人主义" ./DUMP-TEXT/$counter_table-$counter_line.txt > ./CONTEXTES/$counter_table-$counter_line-contexte.txt

	langid=`python3 ./PROGRAMMES/LANGID.py ./DUMP-TEXT/$counter_table-$counter_line.txt`
	if [[ $langid == "fr" ]]
	then
		egrep -o "\w+" ./DUMP-TEXT/$counter_table-$counter_line.txt > b1
		tail -n +2 < b1 > b2
		paste b1 b2 | sort -fg | uniq -ic | sort -rn > ./BIGRAMMES/$counter_table-$counter_line-bigrammes.txt
		rm b1 b2
	else
		python3 ./PROGRAMMES/TOKENIZE.py ./DUMP-TEXT/$counter_table-$counter_line.txt ./TOKENS-CHINOIS/token-counter_table-$counter_line.txt
		egrep -o "\w+" ./TOKENS-CHINOIS/token-counter_table-$counter_line.txt > b1
		tail -n +2 < b1 > b2
		paste b1 b2 | sort -fg | uniq -ic | sort -rn > ./BIGRAMMES/$counter_table-$counter_line-bigrammes.txt
		rm b1 b2
	fi

	python3 ./PROGRAMMES/context_html.py ./DUMP-TEXT/$counter_table-$counter_line.txt "individualisme|个人主义" UTF-8 ./CONTEXTES/$counter_table-$counter_line-contexte.html

	freq_keyword=`egrep -o -i "individualisme|个人主义" < ./DUMP-TEXT/$counter_table-$counter_line.txt | wc -l`
	
	echo "<tr>" >> $1
	echo "<td>$counter_line</td>" >> $1
	echo "<td>$http_code</td>" >> $1
	echo "<td>$langid</td>" >> $1
	echo "<td><a href=\"$line\" target=\"_blank\">$line</a></td>" >> $1
	echo "<td><a href=\"../PAGES-ASPIREES/$counter_table-$counter_line.html\" target=\"_blank\">Page $counter_table-$counter_line</a></td>" >> $1
	echo "<td>$encoding</td>" >> $1
	echo "<td><a href=\"../DUMP-TEXT/$counter_table-$counter_line.txt\">Text $counter_table-$counter_line</a></td>" >> $1
	echo "<td><a href=\"../CONTEXTES/$counter_table-$counter_line-contexte.txt\" target=\"_blank\">Context $counter_table-$counter_line</a></td>" >> $1
	echo "<td><a href=\"../CONTEXTES/$counter_table-$counter_line-contexte.html\" target=\"_blank\">Context Html $counter_table-$counter_line</a></td>" >> $1
	echo "<td><a href=\"../BIGRAMMES/$counter_table-$counter_line-bigrammes.txt\" target=\"_blank\">Bigram $counter_table-$counter_line</a></td>" >> $1
	echo "<td>$freq_keyword</td>" >> $1
	echo "</tr>" >> $1
}

processing_other() # parameter: html file
{
	lynx -dump -nolist --assume-charset="$encoding" --display-charset="$encoding" $line > ./DUMP-TEXT/$counter_table-$counter_line.txt
	curl -SL -o ./PAGES-ASPIREES/$counter_table-$counter_line.html $line
	iconv -f $encoding -t UTF-8 ./DUMP-TEXT/$counter_table-$counter_line.txt > ./DUMP-TEXT/$counter_table-$counter_line-UTF-8.txt
	rm ./DUMP-TEXT/$counter_table-$counter_line.txt

	egrep -C 1 -i "individualisme|个人主义" ./DUMP-TEXT/$counter_table-$counter_line-UTF-8.txt > ./CONTEXTES/$counter_table-$counter_line-contexte.txt
	
	langid=`python3 ./PROGRAMMES/LANGID.py ./DUMP-TEXT/$counter_table-$counter_line-UTF-8.txt`
	if [[ $langid == "fr" ]]
	then
		egrep -o "\w+" ./DUMP-TEXT/$counter_table-$counter_line-UTF-8.txt > b1
		tail -n +2 < b1 > b2
		paste b1 b2 | sort -fg | uniq -ic | sort -rn > ./BIGRAMMES/$counter_table-$counter_line-bigrammes.txt
		rm b1 b2
	else
		python3 ./PROGRAMMES/TOKENIZE.py ./DUMP-TEXT/$counter_table-$counter_line-UTF-8.txt ./TOKENS-CHINOIS/token-counter_table-$counter_line.txt
		python3 ./PROGRAMMES/TOKENIZE.py ./DUMP-TEXT/$counter_table-$counter_line.txt ./TOKENS-CHINOIS/token-counter_table-$counter_line.txt
		egrep -o "\w+" ./TOKENS-CHINOIS/token-counter_table-$counter_line.txt > b1
		tail -n +2 < b1 > b2
		paste b1 b2 | sort -fg | uniq -ic | sort -rn > ./BIGRAMMES/$counter_table-$counter_line-bigrammes.txt
		rm b1 b2
	fi

	python3 ./PROGRAMMES/context_html.py ./DUMP-TEXT/$counter_table-$counter_line-UTF-8.txt "individualisme|个人主义" UTF-8 ./CONTEXTES/$counter_table-$counter_line-contexte.html

	freq_keyword=`egrep -o -i "individualisme|个人主义" < ./DUMP-TEXT/$counter_table-$counter_line-UTF-8.txt | wc -l`

	echo "<tr>" >> $1
	echo "<td>$counter_line</td>" >> $1
	echo "<td>$http_code</td>" >> $1
	echo "<td>$langid</td>" >> $1
	echo "<td><a href=\"$line\" target=\"_blank\">$line</a></td>" >> $1
	echo "<td><a href=\"../PAGES-ASPIREES/$counter_table-$counter_line.html\" target=\"_blank\">Page $counter_table-$counter_line</a></td>" >> $1
	echo "<td>$encoding</td>" >> $1
	echo "<td><a href=\"../DUMP-TEXT/$counter_table-$counter_line-UTF-8.txt\" target=\"_blank\">Text(UTF8) $counter_table-$counter_line</a></td>" >> $1
	echo "<td><a href=\"../CONTEXTES/$counter_table-$counter_line-contexte.txt\" target=\"_blank\">Context $counter_table-$counter_line</a></td>" >> $1
	echo "<td><a href=\"../CONTEXTES/$counter_table-$counter_line-contexte.html\" target=\"_blank\">Context Html $counter_table-$counter_line</a></td>" >> $1
	echo "<td><a href=\"../BIGRAMMES/$counter_table-$counter_line-bigrammes.txt\" target=\"_blank\">Bigram $counter_table-$counter_line</a></td>" >> $1
	echo "<td>$freq_keyword</td>" >> $1
	echo "</tr>" >> $1
}

processing_other2()
{
	echo "<tr>" >> $1
	echo "<td>$counter_line</td>" >> $1
	echo "<td>$http_code</td>" >> $1
	echo "<td>CodeError</td>" >> $1
	echo "<td><a href=\"$line\" target=\"_blank\">$line</a></td>" >> $1
	echo "<td>CodeError</td>" >> $1
	echo "<td>CodeError</td>" >> $1
	echo "<td>CodeError</td>" >> $1
	echo "<td>CodeError</td>" >> $1
	echo "<td>CodeError</td>" >> $1
	echo "<td>CodeError</td>" >> $1
	echo "<td>CodeError</td>" >> $1
	echo "</tr>" >> $1
}

combine()
{
	for file in `ls $1 | egrep ".txt"`
	{
	echo -e "<FILENAME = $file>\n" >> $2
	cat $1/$file >> $2
	echo -e "\n<THE END OF $file>\n" >> $2
	}
}

write_html_conclusion()
{
	echo "<tr>" >> $1
	echo "<td>DONE</td>" >> $1
	echo "<td>DONE</td>" >> $1
	echo "<td>DONE</td>" >> $1
	echo "<td>DONE</td>" >> $1
	echo "<td>DONE</td>" >> $1
	echo "<td>DONE</td>" >> $1
	echo "<td><a href=\"../DUMP-TEXT/TOTAL_TEXT.txt\" target=\"_blank\">TOTAL_TEXT</a></td>" >> $1
	echo "<td><a href=\"../CONTEXTES/TOTAL_CONTEXTE.txt\" target=\"_blank\">TOTAL_CONTEXT</td>" >> $1
	echo "<td>DONE</td>" >> $1
	echo "<td>DONE</td>" >> $1
	echo "<td>DONE</td>" >> $1
	echo "</tr>" >> $1
}
