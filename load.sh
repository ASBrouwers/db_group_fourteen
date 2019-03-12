#!/bin/bash
#load script group 14
psql -d uni -f createtables.sql
psql -d uni -f loaddata.sql
psql -d uni -f manageprimarykeys.sql
