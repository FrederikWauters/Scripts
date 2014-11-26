#!/bin/bash 
#
# mu job submission script
# created Volodya Tishchenko 14-Dec-2010
#
# set to -o for verbose
#set -o verbose
source ~/.bashrc

# Parameters to adjust

#define these parameters
mta="./mta"
#INP_DIR=/muonstorage/analysispass/ProdJun2012/tree
INP_DIR="/data/scratch"
#OUT_DIR=/SCRATCH/mhmurray/tmp
OUT_DIR="/data/frederik/mtafiles"
#STDOUT_DIR=/SCRATCH/mhmurray/joboutput
STDOUT_DIR=${HOME}/tmp

# check command line arguments 
if [ $# -ne 1 ]; then
   echo "Usage: run_number "
   exit 0
fi

# simplified to use same directory as run_no
mdir=$1 
run=$1

# create working directory
if [ ! -d $mdir ]; then
   mkdir $mdir
fi

if [ ! -d $mdir ]; then
   echo "***ERROR! Cannot create directory $mdir"
   exit 1
fi

# make sure that the requested slot is free
fpid=$mdir"/pid"
if [ -f $fpid ]; then
   pid_stale=`cat $fpid`
   echo "***ERROR! Slot is busy! "
   echo "Wait or kill the task manually with kill $pid_stale"
   echo "and remove the file $fpid"
   exit 2
fi

pid=$$
echo $fpid
echo $pid > $fpid

pwd=`pwd`
export MIDAS_DIR=$pwd"/"$mdir

echo "Using midas working directory [$MIDAS_DIR]"

cmd="$mta -i $INP_DIR/tree$run.root  -o $OUT_DIR/mta$run.root  "   
echo "`date`: Starting mta as [$cmd]..." > $STDOUT_DIR/$run.stdout
$cmd >> $STDOUT_DIR/$run.stdout
#stty sane

#clean the working directory
echo "cleaning working directory $mdir ..."
rm $fpid
rm -rf $mdir





