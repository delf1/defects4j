#!/usr/bin/env bash
################################################################################
#
# This script tests the test generation using Randoop.
#
################################################################################
# Import helper subroutines and variables, and init Defects4J
source test.include
init

if [ "$#" -ne 3 ]; then
    die "usage: `basename "$0"` <project_name> <bug_id> <randoop_dir>"
fi

# Generate tests for Lang-2
pid=$1
bid=$2

# Directory for Randoop test suites
randoop_dir=$3

vid=${bid}f

run_randoop.pl -p $pid -v $vid -n 1 -o $randoop_dir -b 180 || die "run Randoop on $pid-$vid"
