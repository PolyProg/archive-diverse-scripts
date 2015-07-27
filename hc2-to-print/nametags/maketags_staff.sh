#!/bin/bash
set -e

rm -rf .temps || true
mkdir .temps

for i in `seq -w 1 100`; do echo >> .temps/empty.txt; done

wget "http://hc2.ch/admin/outputraw.php?stafftags&username=bot&password=5qi2pxumrj6ab98f" -O .temps/staff.txt
cat sponsor.txt >> .temps/staff.txt
sed -i "s/\\\\/\\\\\\\\/g" .temps/staff.txt

cat .temps/staff.txt .temps/empty.txt | (
for f in `seq -w 1 3`; do
        DEST=.temps/staff$f.svg
        DESTPDF=.temps/staff$f.pdf
	cp staff.svg $DEST
	for i in `seq 1 9`; do
        	echo S $f $i
		read given
		read sur
                read aff
		sed --posix -i "s/#FIRST$i#/$given/g" $DEST
		sed --posix -i "s/#LAST$i#/$sur/g" $DEST
		sed --posix -i "s/#SCHOOL$i#//g" $DEST
		sed --posix -i "s/#TEAM$i#/$aff/g" $DEST
	done
	inkscape $DEST -A $DESTPDF -C -T
done
)
pdftk .temps/staff*.pdf .temp/nametags*.pdf output all.pdf
