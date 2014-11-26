#!/bin/bash 
#
# mu job submission script
# created Volodya Tishchenko 14-Dec-2010
#
# set to -o for verbose
set +o verbose
source ~/.bashrc

# Parameters to adjust

#define these parameters
masterodb="../odb/frederik.odb"
echo $masterodb
MU="./mu"
INP_DIR="/muonstorage/run5/incoming"
OUT_DIR="/data/scratch"

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

echo "Loading master odb [$masterodb]"
odbedit -c "load $masterodb" 

cmd="$MU -i $INP_DIR/run$run.mid -o $OUT_DIR/hist$run.root -T $OUT_DIR/tree$run.root "
echo "Starting mu as [$cmd]..."
$cmd 
stty sane

#clean the working directory
echo "cleaning working directory $mdir ..."
rm $fpid
rm $mdir/.*.SHM





