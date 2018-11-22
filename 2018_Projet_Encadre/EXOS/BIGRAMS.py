#!/usr/bin/python
# -*- coding: utf-8 -*-
import re
import sys
import io
import jieba
import nltk
from collections import Counter
import os
from TOKENIZE import tokenize


def bigram():
	wordlist=tokenize(sys.argv[1])
	for i in list(nltk.bigrams(wordlist)):
		with io.open('temp.txt','a',encoding='utf-8') as f:
			f.write(i[0]+"\t"+i[1]+'\n')

def bigram_sort(output):
	bigram()
	with io.open('temp.txt','r',encoding='utf-8') as f:
		data=f.readlines()
	res=Counter(data).most_common(len(data))
	with io.open(output,'a',encoding='utf-8') as f1:
		for i in res:
			f1.write(i[0]+"\t"+str(i[1])+"\n")
	os.remove('temp.txt')
bigram_sort(sys.argv[2])
