# Contributors: Christopher Vogt, Titus Cieslewski
import csv, re, os, sys

def is_number(s):
  try:
    float(s)
    return True
  except ValueError:
    return False
    
#DSC_0356.JPG
#file://HC2PHOTOLIBRARY


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
    row[6], # photo
    row[7], # category
    [name.strip() for name in row[9].split(",")] # team members
    ) for row in rankreader]
  
student_scores = sorted([score for score in scores],key=lambda s:s[2])

def clean(string):
  return re.sub(r"[^a-zA-Z0-9.]", "_", string)

def create_slides(scores, max_rank):
  pdfnames = []
  for score in scores:
    teamid,team,rank,score,penalties,time,photo,cat,players = score
    if rank > max_rank:
      break
    # fill in template
    filename = str(rank) + "-" + str(teamid)
    print filename
    with open('out/'+filename+'.svg','w') as new_file, open('template-2015.svg') as old_file:
      for line in old_file:
        new_file.write(line.replace('NAMESNAME1', "<![CDATA["+players[0]+"]]>").replace('NAMESNAME2', "<![CDATA["+(players[1] if len(players) >= 2 else "")+"]]>").replace('NAMESNAME3', "<![CDATA["+(players[2] if len(players) >= 3 else "")+"]]>").replace('RANKRANK', ("And finally, on" if (rank==1) else "On")+" rank "+str(rank)).replace('TEAMTEAM', "<![CDATA["+(team+'*' if (cat == '1') else team)+"]]>").replace('POINTSPOINTS', "With "+str(score)+" "+("point" if (score=='1') else "points")+", a total time of "+str(time)+" and a penalty of "+penalties).replace('HC2PHOTOLIBRARY', os.path.join(os.path.abspath('.'),'photos-2015','DSC_0'+photo+'.JPG')))
    
    # Convert svg to pdf
    #print 'rsvg-convert -f pdf -o out/'+filename+'.pdf out/'+filename+'.svg'
    #os.system('rsvg-convert -f pdf -o "out/'+filename+'.pdf" "out/'+filename+'.svg"')
    print 'inkscape out/'+filename+'.svg --export-pdf=out/'+filename+'.pdf'
    os.system('inkscape out/'+filename+'.svg --export-pdf=out/'+filename+'.pdf')
    os.system('convert -density 200x200 -quality 60 -compress jpeg out/'+filename+'.pdf out/'+filename+'_small.pdf')
    
    pdfnames.append('out/'+filename+'_small.pdf')
  
    # remove svg
    # os.system('rm out/'+filename+'.svg')
  pdfnames.reverse()
  pdfcat = ' '.join(pdfnames)
  catcommand = 'pdftk ' + pdfcat + ' cat output slides.pdf'
  print catcommand
  os.system(catcommand)

os.system('mkdir -p out')
create_slides(student_scores, 30)

