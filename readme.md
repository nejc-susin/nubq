# NubQ
> A very simple bash script queuing system.

> **NubQ** is a work in progress. Any and all suggestions, criticisms and contributions are most welcome. 

### HOW IT WORKS
* Users add their scripts to the queue by calling `enqueue FILE1.sh FILE2.sh ...`
* Enqueue copies their script to the `jobs` dir, renames them and prepends a header.
* Q (the job runner) periodically scans the `jobs` dir and runs jobs in the order they were added. 
* Once completed, the output, error log and the jobfile are moved to the `done` dir.

### ORGANIZATION
NubQ is installed to `/` by default. This is the directory structure:

```
/nubq/
	nubq/
		KILLSWITCH 		# killswitch file
		config.sh
		enqueue			# command to add scripts to queue
		install.sh
		q.sh			# Q - the actual job runner
		readme.md
		start-q			# startup script
		uninstall.sh
	done/
		*.out 			# output of the job 
		*.err 			# error output of the job
		*.done 			# completed jobfile
	jobs/
		*.job 			# jobfile
	error.log 			# error log
	jobs.log 			# activity log
```
The `/nubq/nubq/` folder is added to PATH for all users at installation, so everyone can call enqueue and start-q from anywhere.

### LOGGING
Logs are located in the NubQ root dir. The `jobs.log` keeps track of when jobs were started and whether they completed successfully or not (*Hint: you can grep by username to get a list of all jobs by given user*). 
```
DATE_TIME job NAME by USER was started
DATE_TIME job NAME by USER completed SUCCESSFULLY (running time)

DATE_TIME job NAME by USER was started
DATE_TIME job NAME by USER completed WITH ERRORS (running time)
```
The `error.log` is the error out redirect.

### JOBS
A job is simply a bash script. It awaits its turn to be executed in the `jobs` dir and is moved into the `done` dir once completed. 
When added to the queue, a header is prepended to the top of the file. Once the job is completed, another header is prepended. A done job file will therefore look like this: 

```
# -----------------------------------
# started on DATETIME
# finished on DATETIME
# running time DURATION
# -----------------------------------
# file UNIX_TIMESTAMP-USER.job
# submitted by USERNAME
# submitted on DATETIME
# -----------------------------------
<the commands to run>
```

The jobfile's filename contains the timestamp of when it entered the queue and the name of the user that submitted it.
The `done` dir contains the jobfiles that were completed, along with their output and error log.

### KILLSWITCH
The killswitch is a simple mechanism to stop Q. It's an empty file, located in Q's root directory. Q checks for its existence before starting a job and won't run if it is not present. To stop Q, delete, move or rename the file. Q will end on the next loop iteration and you will have to run it again. 
Note, that the killswitch has no effect while Q is executing a job - this does not protect us from infinite loops within job scripts, it just makes it easier to stop the daemon.

### INSTALLATION & USAGE
* clone the repo or download zip
* run `./install.sh` (you have to be inside the dir!)
* if no errors were generated, you are good to go!

* run `start-q` to start up the job runner daemon (you will have to do this after every reboot)
* use `enqueue [SCRIPT1 SCRIPT2 ...]` to enqueue jobs

### TROUBLESHOOTING
If `start-q` is not recognised immediately after installation try logging out and back in.
If still no juice - make sure `/nubq/nubq` is in your `PATH` environment variable.
Check the permissions on files in NubQ root dir. `KILLSWITCH` and `jobs` dir should be 777, the rest is 755. 
If you changed the root path in the install script from `/nubq` to something else, check the other files and make changes accordingly.

### TODO
* stop-q
* look into running as a service
* find a way to forcefully stop a running job
