#############
# LOCATIONS #
#############

ROOT_DIR='/nubq'
QUEUE_DIR="$ROOT_DIR/jobs/"			# incoming queue
DONE_DIR="$ROOT_DIR/done/"			# save job results

LOGFILE="$ROOT_DIR/jobs.log"		# records operations
ERRFILE="$ROOT_DIR/error.log"   	# records errors

KILLSWITCH="$ROOT_DIR/nubq/KILLSWITCH"	# remove this file to stop Q

JOB_EXT='.job'
DONE_EXT='.done'
OUT_EXT='.out'
ERR_EXT='.err'

#############
#  STRINGS  #
#############

JOBSTART_MSG="was started"
JOBDONE_OK_MSG="completed OK"
JOBDONE_ERR_MSG="completed WITH ERRORS"

DATETIME_NICE='+%Y-%m-%d_%H:%M:%S'

LOG_MSG='%s | %s %s\n'		# DATETIME | JOB EVENT

JOB_HEADER_1='# -----------------------------------\n# file %s\n# submitted by %s\n# submitted on %s\n# -----------------------------------\n# -----------------------------------'

JOB_HEADER_2='# -----------------------------------\n# started on %s\n# finished on %s\n# running time %s\n'
