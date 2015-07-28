#!/bin/bash
set -e

sheets=31

rm -rf .temp || true
mkdir .temp

for i in `seq -w 1 100`; do echo >> .temp/empty.txt; done

wget "http://hc2.ch/admin/outputraw.php?prize&username=bot&password=5qi2pxumrj6ab98f" -O .temp/cont2.txt
echo "-- Prizes --" > .temp/cont.txt
cat first.txt >> .temp/cont.txt
cat .temp/cont2.txt >> .temp/cont.txt
sed -i "s/\\\\/\\\\\\\\/g" .temp/cont.txt

win1=""
win2=""
win3=""
win4=""
win5=""
win6=""

cat .temp/cont.txt .temp/empty.txt | (
for f in `seq -w 0 $sheets`; do
        DEST=.temp/info$f.svg
        DESTPDF=.temp/info$f.pdf
	cp info.svg $DEST

        echo $f
        win6=$win5
        win5=$win4
        win4=$win3
        win3=$win2
        win2=$win1
        read win1
        sed --posix -i \
          -e "s/#WIN1#/$win1/g" \
          -e "s/#WIN2#/$win2/g" \
          -e "s/#WIN3#/$win3/g" \
          -e "s/#WIN4#/$win4/g" \
          -e "s/#WIN5#/$win5/g" \
          -e "s/#WIN6#/$win6/g" \
          -e "s/#PAGE#/$f/g" \
          $DEST

	inkscape $DEST -A $DESTPDF -C -T
done
)

pdftk .temp/info*.pdf output .temp/all.pdf
pdftk .temp/all.pdf background background.pdf output all.pdf
