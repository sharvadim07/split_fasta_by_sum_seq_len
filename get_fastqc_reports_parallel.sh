#!/bin/bash

THREADS=$1
LOG=`pwd`/get_fastqc_reports.log

FASTQ_FILES=`find ./ -name "*.f*q"`

date >> ${LOG}
echo "Start iterations of FastQC." >> ${LOG}
thread_counter=0
for fastq_file in `echo ${FASTQ_FILES}`;
do
    echo "Proc ${fastq_file}" >> ${LOG}
    
    if (( ${thread_counter} >= ${THREADS} ))
    then
        # run last process in batch and wait
        echo "Thread runned for ${fastq_file}. Waiting..." >> ${LOG}
        echo "Threads counter = ${thread_counter}." >> ${LOG}
        # wait for all pids
        wait;
        thread_counter=0
    fi
    # run processes and store pids in array
    fastqc ${fastq_file} &
    thread_counter=$((thread_counter+1))
    date >> ${LOG}
    echo "Thread runned for ${fastq_file}." >> ${LOG}
    sleep 2

done
# Waiting of the rest of threads
date >> ${LOG}
echo "Waiting..." >> ${LOG}
wait;

date >> ${LOG}
echo "End iterations of FastQC." >> ${LOG}

date >> ${LOG}
echo "Start MultiQC for FastQC reports." >> ${LOG}
#multiqc -m fastqc -d ./
multiqc -m fastqc -d `find ./ -type d -name *trim*` --title after_trimmomatic
multiqc -m fastqc -d `find ./ -type d -name *rad_tags*` --title after_radtags
date >> ${LOG}
echo "End MultiQC for FastQC reports." >> ${LOG}
