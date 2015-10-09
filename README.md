Description
-----------

Find MySQL invalid foreign keys.


How to use?
-----------

```
sh check.sh -u <username> -h <host> -d <database>
```

A file *result.txt* will be created with list of all orphans.

Example
-------

```
sh check.sh -u root -h 127.0.0.1 -d my_database
```