Cron Role
=========

Installs and configures a Cron service


Role Variables
--------------

```
# Defaults
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
  - magento_main:
    job: echo test
    name: test1
    file: magento-main
    user: www-data
    minute: 1
  - magento_default
    job: echo magento
    name: magento
    file: magento-default
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
