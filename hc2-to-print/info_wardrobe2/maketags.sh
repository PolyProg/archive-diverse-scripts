#!/bin/bash
set -e

sheets=67

rm -rf .temp || true
mkdir .temp

for i in `seq -w 1 100`; do echo >> .temp/empty.txt; done

wget "http://hc2.ch/admin/outputraw.php?infow&username=bot&password=5qi2pxumrj6ab98f" -O .temp/cont.txt
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
        read wardrobe
        read owed
        read name1
        read aff1
        read lang1
        read tee1
        read name2
        read aff2
        read lang2
        read tee2
        read name3
        read aff3
        read lang3
        read tee3
        if [ "x${room:0:2}" == "xCO" ]; then
          room=${room:2}
        fi
        sed --posix -i \
          -e "s/#TEAMID#/$teamid/g" \
          -e "s/#WARDROBE#/$wardrobe/g" \
          -e "s/#TEAM#/$teamname/g" \
          -e "s/#ROOM#/$room/g" \
          -e "s/#SEAT#/$place/g" \
          -e "s/#CAN1#/$name1/g" \
          -e "s/#CAN2#/$name2/g" \
          -e "s/#CAN3#/$name3/g" \
          -e "s/#AFF1#/$aff1/g" \
          -e "s/#AFF2#/$aff2/g" \
          -e "s/#AFF3#/$aff3/g" \
          -e "s/#LANG1#/$lang1/g" \
          -e "s/#LANG2#/$lang2/g" \
          -e "s/#LANG3#/$lang3/g" \
          -e "s/#TEE1#/$tee1/g" \
          -e "s/#TEE2#/$tee2/g" \
          -e "s/#TEE3#/$tee3/g" \
          -e "s/#PAGE#/$f/g" \
          $DEST

	inkscape $DEST -A $DESTPDF -C -T
done
)

pdftk .temp/info*.pdf output all.pdf
