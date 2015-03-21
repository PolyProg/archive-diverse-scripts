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
  scores = [(
    row[0], # team id
    row[1], # team name
    int(row[2]) if is_number(row[2]) else 99999, # rank
    row[3], # score
    row[4], # penalties
    row[5], # time
    row[7], # category
    [name.strip() for name in row[9].split(",")] # team members
    ) for row in rankreader]

student_scores = sorted([score for score in scores if score[-2] == "0"],key=lambda s:s[2])

def clean(string):
  return re.sub(r"[^a-zA-Z0-9.]", "_", string)

def create_slides(scores, max_rank):
  pdfnames = []
  for score in scores:
    teamid,team,rank,score,penalties,time,cat,players = score
    if rank > max_rank:
      break
    # fill in template
    filename = str(rank) + "-" + str(teamid)
    print filename
    with open('out/'+filename+'.svg','w') as new_file, open('template-2015.svg') as old_file:
      for line in old_file:
        new_file.write(line.replace('NAMESNAMES', "<![CDATA["+'\n'.join(players)+"]]>").replace('RANKRANK', ("And finally, on" if (rank==1) else "On")+" rank "+str(rank)).replace('TEAMTEAM', "<![CDATA["+team+"]]>").replace('POINTSPOINTS', "With "+str(score)+" points, a total time of "+str(time)+" and a penalty of "+penalties))
    
    # Convert svg to pdf
    print 'rsvg-convert -f pdf -o out/'+filename+'.pdf out/'+filename+'.svg'
    os.system('rsvg-convert -f pdf -o "out/'+filename+'.pdf" "out/'+filename+'.svg"')
    
    pdfnames.append('out/'+filename+'.pdf')
  
    # remove svg
    # os.system('rm out/'+filename+'.svg')
  pdfnames.reverse()
  pdfcat = ' '.join(pdfnames)
  catcommand = 'pdftk ' + pdfcat + ' cat output slides.pdf'
  print catcommand
  os.system(catcommand)

os.system('mkdir -p out')
create_slides(student_scores, 6)

