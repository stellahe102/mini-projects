#!/bin/bash
####################
# set Default variable

filenametime1=$(date +"%m%d%Y%H%M%S")

####################
# create subfolders
# mkdir scripts; mkdir logs # comment this line out after the folders are created
# set variables
export BASE_FOLDER='/home/ubuntu/Miniproject/week1'
export SCRIPTS_FOLDER='/home/ubuntu/Miniproject/week1/scripts'
export INPUT_FOLDER='/home/ubuntu/Miniproject/week1/input'
export OUTPUT_FOLDER='/home/ubuntu/Miniproject/week1/output'
export LOGDIR='/home/ubuntu/Miniproject/week1/logs'
export SHELL_SCRIPT_NAME='Toronto_climate'
export LOG_FILE=${LOGDIR}/${SHELL_SCRIPT_NAME}_${filenametime1}.log
export PYTHON_SCRIPT_NAME='Toronto_climate.py'

# go to script folder directory
cd ${SCRIPTS_FOLDER}

# set log rules: put the standard error to the same place as the standard output
exec > >(tee ${LOG_FILE}) 2>&1

# empty the folder before downloading
cd .. # go 1 folder up
rm input/* # remove all the existing files in input folder
cd ${SCRIPTS_FOLDER} # go to the script folder

####################
# start downloading the data from url

echo "Start downloading data"

for year in {2020..2023}
    # do curl -o ${INPUT_FOLDER}/${year}.csv "https://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=48549&Year=${year}&Month=2&Day=14&timeframe=1&submit= Download+Data"
    # need to install wget to run below
    do wget -N --content-disposition "https://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=48549&Year=${year}&Month=2&Day=14&timeframe=1&submit= Download+Data" -O $INPUT_FOLDER/${year}.csv
    done;
RC1=$?
# if there is a failure during the downloading
if [ $RC1 != 0 ]
then
    echo "DOWNLOAD DATA FAILED"
	echo "[ERROR:] RETURN CODE:  ${RC1}"
	# echo "[ERROR:] REFER TO THE LOG FOR THE REASON FOR THE FAILURE."
	exit 1
fi
echo "downloading individual files succeeded"
#######################
# run python script
echo 'start running python script to concatenate the individual files to one'
python3 ${SCRIPTS_FOLDER}/$PYTHON_SCRIPT_NAME

RC1=$?
if [ ${RC1} != 0 ]
then
	echo "PYTHON RUNNING FAILED"
	echo "[ERROR:] RETURN CODE:  ${RC1}"
	# echo "[ERROR:] REFER TO THE LOG FOR THE REASON FOR THE FAILURE."
	exit 1 
    # specify the existing status otherwise defult will be 0 
    # since the echo lines run successfully
fi

echo "python script succeeded"

exit 0