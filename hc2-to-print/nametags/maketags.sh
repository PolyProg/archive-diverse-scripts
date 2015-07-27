#!/bin/bash
set -e

sheets=20

rm -rf .temp || true
mkdir .temp

for i in `seq -w 1 100`; do echo >> .temp/empty.txt; done

wget "http://hc2.ch/admin/outputraw.php?tags&username=bot&password=5qi2pxumrj6ab98f" -O .temp/cont.txt
sed -i "s/\\\\/\\\\\\\\/g" .temp/cont.txt

cat .temp/cont.txt .temp/empty.txt | (
for f in `seq -w 1 $sheets`; do
        DEST=.temp/nametags$f.svg
        DESTPDF=.temp/nametags$f.pdf
	cp nametags.svg $DEST
	for i in `seq 1 9`; do
        	echo $f $i
		read team
		read given
		read sur
		read uni
                read lang
                read room
                read seat
                read uid
                read teamid
                read wardrobe
                if [ "x${room:0:2}" == "xCO" ]; then
                  room=${room:2}
                fi
                langcmd="s/#ffeea$i/#000000/g"
                if [ "x$lang" == "xF" ]; then
                  langcmd="s/#ffeea$i/#d5e5ff/g"
                fi
                if [ "x$lang" == "xD" ]; then
                  langcmd="s/#ffeea$i/#e6e65c/g"
                fi
                if [ "x$lang" == "xE" ]; then
                  langcmd="s/#ffeea$i/#ffd5d5/g"
                fi
		sed --posix -i -e "s/#FIRST$i#/$given/g" \
                  -e "s/#LAST$i#/$sur/g" \
                  -e "s/#SCHOOL$i#/$uni/g" \
                  -e "s/#TEAM$i#/$team/g" \
                  -e "s/#ROOM$i#/$room/g" \
                  -e "s/#TEAMID$i#/$teamid/g" \
                  -e "s/#UID$i#/$uid/g" \
                  -e "s/#WARDROBE$i#/$wardrobe/g" \
                  -e "s/#PAGE#/$f/g" \
                  -e "$langcmd" \
                  -e "s/#SEAT$i#/$seat/g" $DEST
	done
	inkscape $DEST -A $DESTPDF -C -T
done
)

pdftk .temps/staff*.pdf .temp/nametags*.pdf output all.pdf
