#!/bin/bash
psql -d uni -f createtables.sql
psql -d uni -f loaddata.sql

