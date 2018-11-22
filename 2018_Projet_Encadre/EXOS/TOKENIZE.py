#!/usr/bin/python
# -*- coding: utf-8 -*-
import re
import sys
import io
import jieba



def tokenize(file):
	with io.open(file,"r",encoding='utf-8') as f:
		data=f.read()
	pattern=re.compile(u'[^\u4E00-\u9FA5]')
	text=pattern.sub(r"", data)
	wordlist_temp=list(jieba.cut(text))
	wordlist=[i.rstrip() for i in wordlist_temp if len(i)>=1]
	return wordlist

def token_file(file):
	wordlist=tokenize(sys.argv[1])
	with io.open(file,'w',encoding='utf-8') as f:
		f.write(" ".join(wordlist))

if __name__ == '__main__':
	token_file(sys.argv[2])
