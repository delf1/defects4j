#!/usr/bin/env bash
################################################################################
#
# This script tests the test generation using EvoSuite.
#
################################################################################
source test.include
init

if [ "$#" -ne 5 ]; then
    die "usage: `basename "$0"` <project_name> <bug_id>"
fi

pid=$1
bid=$2

# Directory for EvoSuite test suites
evo_dir=$3

# Test suite source and number
suite_src=$4
suite_num=$5
suite_dir=$evo_dir/$pid/$suite_src/$suite_num

# Verify that each target class is tested
# EvoSuite should generate one test class per target class
check_target_classes() {
    [ $# -eq 3 ] || die "usage: ${FUNCNAME[0]} <vid> <bid> <classes_dir>"
    local vid=$1
    local bid=$2
    local classes_dir=$3

    for class in $(cat "$BASE_DIR/framework/projects/$pid/$classes_dir/${bid}.src"); do
        file=$(echo $class | tr '.' '/')
        bzgrep -q "$file" "$suite_dir/${pid}-${vid}-evosuite-branch.${suite_num}.tar.bz2" || die "verify target classes ($class not found)"
    done
}

# Run EvoSuite for all modified classes and check whether all target classes are tested
vid=${bid}f
start=`date +%s` 
run_evosuite.pl -p $pid -v $vid -n $suite_num -o $evo_dir -cbranch -b 180 -a 120 || die "run EvoSuite (modified classes) on $pid-$vid"
echo $(( `date +%s` - start ))
check_target_classes $vid $bid "modified_classes"


