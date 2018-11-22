#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import re

def bigrams(filepath,motif,encoding,output):
	pattern=re.compile(motif)
	with open(output,'a') as f1:
		message1='''
<!DOCTYPE>
<html lan="en">
<head>
<meta charset="UTF-8"/><title>Projet de Mot</title>
<style>
span{color:Brown;}
</style>
</head>
<body>
'''
		f1.write(message1)
		f1.write("<p style='color:Green'>FILENAME: <span>")
		f1.write(filepath)
		f1.write("</span></p>")
		f1.write("<p>")

		f1.write("<p style='color:Green'>ENCODING: <span>")
		f1.write(encoding)
		f1.write("</span></p>")
		f1.write("<p>")

		f1.write("<p style='color:Green'>kEYWORD: <span>")
		f1.write(motif)
		f1.write("</span></p>")
		f1.write("<p>")

		f1.write("<p style='color:Green'>OUTPUT: <span>")
		f1.write(output)
		f1.write("</span></p>")
		f1.write("<p>")
		f1.write("<hr/>")

		with open(filepath,"r") as f:
			data=f.readlines()
		counter=0
		for j in range(0,len(data)):
			counter+=1
			data[j]="line "+str(counter)+" : \t\t"+data[j]
		for i in range(1,len(data)-1):
			if pattern.findall(data[i]):
				f1.write("<p style=\"color:Blue\" font><i>")
				f1.write(data[i-1]+"\n")
				f1.write("</i></p>")
				f1.write("<p style=\"color:Red\">")
				f1.write(data[i]+"\n")
				f1.write("</p>")
				f1.write("<p style=\"color:Blue\"><i>")
				f1.write(data[i+1]+"\n")
				f1.write("</i></p>")
				f1.write("<p>-----</p>")
bigrams(sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4])

