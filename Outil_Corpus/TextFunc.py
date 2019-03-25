#! usr/bin/python
# -*- coding:utf-8 -*-

import string,treetaggerwrapper as ttw,sys
import requests,logging
from lxml import etree
from urllib.parse import urlparse

class TextGetter(object):
	"""
	Download the file from webpage
	:Data: url, adress of the object page
	:Return: the file content
	"""
	def __init__(self,url):
		self.url=url

	def GetItem(self,xpath):
		"""get the object item avec xpath"""
		net=urlparse(self.url)
		return [net.scheme+'://'+net.netloc+url for url in 
		etree.HTML(requests.get(self.url).content).xpath(xpath)]

	def GetText(self,xpath):
		"""get the textual content"""
		texts=list()
		urls=self.GetItem(xpath)
		for u in urls: texts.append(str(requests.get(u).content,encoding='utf-8'))
		return texts
		

class TextProcessor(object):
	"""
	For raw text processing
	:Data: text, type string
	:Result: tokenization, ration type/token
	"""
	def __init__(self,text,*args,**kwargs):
		self.text=text

	def PosTagging(self,punct=True):
		"""Tag the string with treetagger"""
		tagger=ttw.TreeTagger(TAGLANG='en',TAGDIR=r'C:\TreeTagger')
		tags=tagger.TagText(self.text)
		return tags
		
	def RatioLexi(self,flag=True):
		"""calculate the ration type/token"""
		tags=self.PosTagging()
		if flag: tokenlist=[t.split('\t')[2] for t in tags]
		else: tokenlist=[t.split('\t')[2] for t in tags if t not in string.punctuation]
		return len(set(tokenlist))/len(tokenlist)

if __name__ == '__main__':
	
	get_text=TextGetter('https://clement-plancq.github.io/outils-corpus/')
	texts=get_text.GetText('//h4/a/@href')

	for text in texts:
		processor=TextProcessor(text)
		ratio=processor.RatioLexi()
		print(f'The type/token ratio of text {texts.index(text)+1} is %.3f.'%ratio)	
	


