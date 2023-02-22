#!/bin/bash
#
# fetch and clean basic data
#

# quiet flag for debugging, reduces / turns off stout
be_quiet=true
q_flag=""
if [ "${be_quiet}" != false ] ;  then
    q_flag="-q"
fi

# # def vars
python_folder="python_scripts"
ziparchive="./ziparchive.zip"
raw_tei_folder="./raw_tei"
editions_folder="./data/editions"
indices_folder="./data/indices"
cases_folder="./data/cases_tei"
boehm_folder="./boehm_tei"
kraus_archive_top_level_folder="${raw_tei_folder}/legalkraus-data-main"
boehm_archive_top_level_folder="${raw_tei_folder}/boehm-retro-main"

# # init import directory
rm -rf $raw_tei_folder
# # 1. kraus archive
# # get data from archive
echo "fetch kraus archive"
wget $q_flag https://github.com/karl-kraus/legalkraus-data/archive/refs/heads/main.zip --output-document=$ziparchive
# # unzip files to directory
unzip $q_flag $ziparchive -d $raw_tei_folder
# # remove old/zip files
rm -rf $ziparchive
rm -rf $editions_folder
rm -rf $indices_folder
rm -rf $cases_folder
# # move new files to destination
mv "${kraus_archive_top_level_folder}/objects" $editions_folder
mv "${kraus_archive_top_level_folder}/old_cols" $cases_folder
mv "${kraus_archive_top_level_folder}/indices" $indices_folder
# # delete current archive import
rm -rf $raw_tei_folder

# # 2. boehm archive
echo "fetch boehm archive"
wget $q_flag https://github.com/karl-kraus/boehm-retro/archive/refs/heads/main.zip --output-document=$ziparchive
# unzip files to directory
unzip $q_flag $ziparchive -d $raw_tei_folder
# # remove old/zip files
rm -rf $ziparchive
rm -rf $boehm_folder
# # move new files to destination
mkdir $boehm_folder
mv "${boehm_archive_top_level_folder}/data/editions" $boehm_folder
# # delete current import
rm -rf $raw_tei_folder



# echo "create cases-index.json"
python "${python_folder}/create_case_index.py"