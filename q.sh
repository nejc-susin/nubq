#! /bin/bash

# The job runner - periodically scans jobs dir and runs containing scripts. 

source config.sh

#exec > >(tee -ia "$LOGFILE")
#exec 2> >(tee -ia "$ERRFILE")

while [ -f "$KILLSWITCH" ]; do
   	for file in $QUEUE_DIR*$JOB_EXT; do   # only .job files
   		[ -e "$file" ] || continue

      filename=$(basename $file)

   		datetime_start=`date $DATETIME_NICE`
      printf "$LOG_MSG" "$datetime_start" "$file" "$JOBSTART_MSG"
      # TODO: send pushbullet?
      
      start=$(date +%s)
      
      bash $file > "$DONE_DIR$filename$OUT_EXT" 2> "$DONE_DIR$filename$ERR_EXT"
      sleep 2

      secs=$(($(date +%s) - start))
      duration=$(printf '%dh %dm %ds' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60)))

      datetime_end=`date $DATETIME_NICE`
      
      number_of_error_lines=$(wc -l < "$DONE_DIR$filename$ERR_EXT")

      if [ "$number_of_error_lines" -gt "0" ]; then
        printf "$LOG_MSG" "$datetime_end" "$file" "$JOBDONE_ERR_MSG ($duration)"
      else
        printf "$LOG_MSG" "$datetime_end" "$file" "$JOBDONE_OK_MSG ($duration)"
      fi

      # make job.done file with header and remove jobfile
      file_done="$DONE_DIR$filename$DONE_EXT"
      header=$(printf "$JOB_HEADER_2" "$datetime_start" "$datetime_end" "$duration")
      echo -e "$header\n$(cat $file)" > $file_done
      rm $file

    done
	sleep 10 # wait 10s before scanning for new files
done
