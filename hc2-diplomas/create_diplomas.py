# Contributors: Christopher Vogt, Titus Cieslewski
import csv, re, os, sys

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

# ranks format: | team id | team name | rank | score | penalties | timepenalty | photo | justforfun? | affiliation | names, separated by comma
with open('ranks.csv', 'rb') as csvfile:
	rankreader = csv.reader(csvfile, delimiter=',', quotechar='"')
	scores = [(row[1],int(row[2]) if is_number(row[2]) else 99999,row[7],[name.strip() for name in row[9].split(",")]) for row in rankreader]
	
mergeCsv = open('mail-merge.csv', 'wb')
mergewriter = csv.writer(mergeCsv, delimiter=',', quotechar='"')
mergewriter.writerow(['FirstName', 'EMail', 'Attachment'])

just_for_fun_scores = sorted([score for score in scores if score[2] == "1"],key=lambda s:s[1])
student_scores = sorted([score for score in scores if score[2] == "0"],key=lambda s:s[1])

def clean(string):
	return re.sub(r"[^a-zA-Z0-9.]", "_", string)

def create_diplomas(scores):
	for score in scores:
		team,rank,cat,players = score
		for player in players:
		  # fill in template
			filename = str(rank)+"-"+clean(team)+"-"+clean(player)
			print filename
			with open('out/'+filename+'.svg','w') as new_file, open('diploma.svg') as old_file:
				for line in old_file:
						new_file.write(line.replace('NAMENAME', player).replace('RANKRANK', "Rank "+str(rank)+(" (professional category)" if (cat=="1") else "")).replace('TEAMTEAM', "<![CDATA["+team+"]]>"))

			# Convert svg to pdf
			print 'rsvg-convert -f pdf -o out/'+filename+'.pdf out/'+filename+'.svg'
			os.system('rsvg-convert -f pdf -o "out/'+filename+'.pdf" "out/'+filename+'.svg"')
			
			# remove svg
			# os.system('rm out/'+filename+'.svg')
			
			# add row to mail-merge csv
			# 1. fetch mail
			# mail format: | id | first | last | mail | team | ...
			with open('mails.csv','rb') as mailcsv:
			  mailreader = csv.reader(mailcsv, delimiter=',', quotechar='"')
			  for row in mailreader:
			    if " ".join([row[1],row[2]]) == player:
			      email = row[3]
			mergewriter.writerow([player.split(" ")[0], email, os.getcwd()+'/out/'+filename+'.pdf'])

os.system('mkdir -p out')
create_diplomas(just_for_fun_scores)
create_diplomas(student_scores)
