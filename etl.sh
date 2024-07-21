#!/bin/bash

mkdir tmp
cd tmp

for y in $(seq 2001 2022); do
	wget https://static.nhtsa.gov/nhtsa/downloads/FARS/$y/National/FARS${y}NationalCSV.zip
	unzip -o FARS${y}NationalCSV.zip -d FARS${y}
done

for y in $(seq 2001 2022); do
	old_csv=$(find FARS${y} -iname accident.csv)
	new_csv=${y}.csv
	echo $new_csv
	iconv -f latin1 -t utf-8//TRANSLIT -o $new_csv $old_csv
	sed -i "s/longitud/LONGITUDE/i" $new_csv
done

seq 2001 2022 | parallel tippecanoe -f -o tiles/{}.pmtiles -r1 -y ST_CASE -y FATALS -y MONTH -y DAY -y YEAR {}.csv
