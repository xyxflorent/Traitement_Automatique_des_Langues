#!/usr/bin/python
# -*- coding: utf-8 -*-
import re
import sys
import io
import langid

def lang_id(file):
	with io.open(file,"r",encoding='utf-8') as f:
		data=f.read(1000)
	pattern=re.compile(u'[\u4E00-\u9FA5]')
	if langid.classify(data)[0]=='zh' and pattern.findall(data):
		print ("cn")
	else:
		print("fr")
lang_id(sys.argv[1])
