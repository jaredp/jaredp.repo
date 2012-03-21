#! /usr/bin/python

import urllib
import json

import string
enwordsfile = open("/Users/Jared/Desktop/words.txt")
enwords = enwordsfile.read()
enwordsfile.close()
enwords = enwords.split("/\n")
enwords = map(string.lower, enwords)

import codecs
translationfile = codecs.open("/Users/Jared/Desktop/translation.txt", encoding='utf-8', mode="w")

for en in enwords:
     url = "https://www.googleapis.com/language/translate/v2?key=AIzaSyB5e7fxO4gHvipGGmKJlYaWI-MN7WkCf6U&source=en&target=es&q=" + en
     translationpage = urllib.urlopen(url)
     sp = json.load(translationpage)["data"]["translations"][0]["translatedText"]
     translationfile.write(en + "," + sp + ";\n")
