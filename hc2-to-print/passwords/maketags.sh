#!/bin/bash
set -e

sheets=67

rm -rf .temp || true
mkdir .temp

for i in `seq -w 1 100`; do echo >> .temp/empty.txt; done

# Important: make sure you insert a valid username and password for hc2.ch/admin
USER="todo"
PASSWORD="todo"

wget "http://hc2.ch/admin/outputraw.php?pwd&username=$USER&password=$PASSWORD" -O .temp/cont.txt
sed -i "s/\\\\/\\\\\\\\/g" .temp/cont.txt

cat .temp/cont.txt .temp/empty.txt | (
for f in `seq -w 1 $sheets`; do
        DEST=.temp/info$f.svg
        DESTPDF=.temp/info$f.pdf
	cp info.svg $DEST

        echo $f
        read teamid
        read teamname
        read room
        read place
        read server
        read con1
        read pwd1
        read con2
        read pwd2
        if [ "x${room:0:2}" == "xCO" ]; then
          room=${room:2}
        fi
        sed --posix -i \
          -e "s/#TEAMID#/$teamid/g" \
          -e "s/#TEAM#/$teamname/g" \
          -e "s/#ROOM#/$room/g" \
          -e "s/#SEAT#/$place/g" \
          -e "s/#SERVER#/$server/g" \
          -e "s/#CON1#/$con1/g" \
          -e "s/#CON2#/$con2/g" \
          -e "s/#PWD1#/$pwd1/g" \
          -e "s/#PWD2#/$pwd2/g" \
          -e "s/#PAGE#/$f/g" \
          $DEST

	inkscape $DEST -A $DESTPDF -C -T
done
)

pdftk .temp/info*.pdf output all.pdf
