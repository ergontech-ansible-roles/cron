[![Build Status](https://travis-ci.org/ergontech-ansible-roles/cron-role.svg?branch=master)](https://travis-ci.org/ergontech-ansible-roles/cron-role)

Cron Role
=========

Installs and configures a Cron service. Creates a file in /etc/cron.d for each


Role Variables
--------------

```
# Vars
cron_jobs

# Required Keys
name
job
file

# Default Key Values
user    -> root
minute  -> *
hour    -> *
day     -> *
weekday -> *
month   -> *
```

```
# Example
cron_jobs:
  - main_job:
    job: echo test
    name: test1
    file: main-job
    user: www-data
    minute: 1
  - secondary_job:
    job: echo 'another test'
    name: second-job
    file: test-file
```


Use Role
----------------

```
# requirments.yml

- src: https://github.com/ergontech-ansible-roles/cron-role
  version: master
  name: cron
```

License
-------

MIT
