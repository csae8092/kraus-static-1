#!/bin/bash
#
# clean files after fetch and tidy up
# 
python_folder="./python_scripts"
editions_folder="./data/editions"
indices_folder="./data/indices"
cases_folder="./data/cases_tei"

echo "delete files without revisionDesc status='done'"
find  -type f -name "D_*.xml" -print0 | xargs --null grep -Z -L 'revisionDesc status="done"' | xargs --null rm

echo "delete file which cannot be parsed by lxml parser"
python "${python_folder}delete_invalid_files.py"

echo "fixing titles"
python "${python_folder}fix_titles.py"

echo "fix entity reference IDs"
find $indices_folder -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@<person xml:id="person__@<person xml:id="pmb@g'
find $indices_folder -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@<bibl xml:id="work__@<bibl xml:id="pmb@g'
find $indices_folder -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@<org xml:id="org__@<org xml:id="pmb@g'
find $indices_folder -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@<place xml:id="place__@<place xml:id="pmb@g'
find $indices_folder -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@<settlement key="@<settlement key="pmb@g'
find $indices_folder -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@<orgName key="@<orgName key="pmb@g'
find $indices_folder -type f -name "*.xml"  -print0 | xargs -0 sed -i -e 's@<placeName key="place__@<placeName key="pmb@g'
find $editions_folder -type f -name "D_*.xml"  -print0 | xargs -0 sed -i 's@ref="#@ref="#pmb@g'
find $editions_folder -type f -name "D_*.xml"  -print0 | xargs -0 sed -i 's@ref="https://pmb.acdh.oeaw.ac.at/entity/@ref="#pmb@g'
find $cases_folder -type f -name "C_*.xml"  -print0 | xargs -0 sed -i 's@ref="https://pmb.acdh.oeaw.ac.at/entity/@ref="#pmb@g'

echo "add xml:id, prev and next attributes"
# doc: https://pypi.org/project/acdh-tei-pyutils/
add-attributes -g "./data/editions/*.xml" -b "https://id.acdh.oeaw.ac.at/legalkraus"
add-attributes -g "./data/indices/*.xml" -b "https://id.acdh.oeaw.ac.at/legalkraus"
add-attributes -g "./data/cases_tei/*.xml" -b "https://id.acdh.oeaw.ac.at/legalkraus"

echo "denormalize indices in objects"
denormalize-indices -f "./data/editions/D_*.xml" -i "./data/indices/*.xml" -m ".//*[@ref]/@ref" -x ".//tei:titleStmt/tei:title[1]/text()" -b pmb11988

echo "denormalize indices in cases"
denormalize-indices -f "./data/cases_tei/C_*.xml" -i "./data/indices/*.xml" -m ".//*[@ref]/@ref" -x ".//tei:titleStmt/tei:title[1]/text()" -b pmb11988

echo "remove listEvent from back elements"
python "{$python_folder}rm_listevent.py"