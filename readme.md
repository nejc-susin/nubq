# NubQ
> A very simple bash script queuing system.

> **NubQ** is a work in progress. Any and all suggestions, criticisms and contributions are most welcome. 

### HOW IT WORKS
* Users add their scripts to the queue by calling `enqueue FILE1.sh FILE2.sh ...`
* Enqueue copies their script to the `jobs` dir, renames them and prepends a header.
* Q periodically scans the `jobs` dir and runs jobs in the order they were added. 
* Once completed, the output, error log and the jobfile are moved to the `done` dir.

### ORGANIZATION
NubQ is installed to `/` by default. This is the directory structure:

```
nubq/
	bin/
		config.sh		# config file
		enqueue			# command to add scripts to queue
		install.sh		# install script
		q.sh			# the actual job runner
		uninstall.sh		# uninstall script
		start-q			# startup script
	done/
		*.out 			# output of the job 
		*.err 			# error output of the job
		*.done 			# completed jobfile
	jobs/
		*.job 			# jobfile
	error.log 			# error log
	jobs.log 			# activity log
	KILLSWITCH 			# killswitch file
	readme.md			# this readme
```
The `nubq/bin/` folder is added to PATH for all users at installation, so everyone can call enqueue from anywhere. (is this ok? Would it be better to just move enqueue to `/usr/local/`?)

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
* clone the repo
* move into `bin` dir and execute `install.sh`
* if no errors were generate, you are good to go!

* run `sudo start-q` to start up the job runner daemon (you will have to do this after every reboot)
* use `enqueue [SCRIPT1 SCRIPT2 ...]` to enqueue jobs

### TROUBLESHOOTING
Make sure `/nubq/bin` is in your `PATH` environment variable.
Check the permissions on files in NubQ root dir. `KILLSWITCH` and `jobs` dir should be 777, the rest is 755. 

### TODO
* stop-q
* uninstall script
* look into running as a service
* find a way to forcefully stop a running job
