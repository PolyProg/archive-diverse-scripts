# Contributors: Titus Cieslewski
import csv
from tempfile import mkstemp
from os import remove, close, system

rankmap = {}
teammap = {}

# Column 1: Rank, column 2: Team name
with open('santa-ranks.csv', 'rb') as csvfile:
	rankread = csv.reader(csvfile, delimiter=',', quotechar='"')
	for row in rankread:
		rankmap[row[1].strip()] = row[0]
	
# Column 2: Full name, column 10: Team name
with open('santa-participants.csv', 'rb') as csvfile:
	teamread = csv.reader(csvfile, delimiter=',', quotechar='"')
	for row in teamread:
		teammap[row[1].strip()] = row[9].strip()

for k,v in teammap.iteritems():
	if v in rankmap:
		print '{0}: {1}.'.format(k,rankmap[v])
		#Create temp file
		abs_path = 'out/temp.svg'
		new_file = open(abs_path,'w')
		old_file = open('santa_diploma.svg')
		for line in old_file:
				new_file.write(line.replace('#NAME', k).replace('#RANK', rankmap[v]))
		#close temp file
		new_file.close()
		old_file.close()
		#Move new file
		print 'rsvg-convert -f pdf -o out/'+k+'.pdf '+abs_path
		system('rsvg-convert -f pdf -o "out/'+k+'.pdf" '+abs_path)
		remove(abs_path)
