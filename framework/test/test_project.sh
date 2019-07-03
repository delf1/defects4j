# Import helper subroutines and variables, and init Defects4J

start=`date +%s`

source test.include
init

[ "$#" -gt 0 ] || die "usage: `basename "$0"` <project_name> [evosuite or randoop]"

pid=$1

# Directory for generated test suites
gen_dir=$TMP_DIR/evosuite

# Directory containing modified classes for a project
classes_dir="modified_classes"

suite_src=evosuite-branch

if [ "$#" -gt 1 ] && [ $2 == "randoop" ]; then
    gen_dir=$TMP_DIR/randoop
    suite_src=randoop
fi

suite_num=1
suite_dir=$gen_dir/$pid/$suite_src/$suite_num

#for bid in $(ls "$BASE_DIR/framework/projects/$pid/$classes_dir" | awk -F '.' '{print $1}'); do
for bid in 1; do
    if [ "$#" -gt 1 ] && [ $2 == "randoop" ]; then
        ./randoop_runner.sh $pid $bid $gen_dir || echo "failed for bug: $bid"
    else
        ./evosuite_runner.sh $pid $bid $gen_dir $suite_src $suite_num || echo "failed for bug: $bid"
    fi
done

# Fix all test suites
fix_test_suite.pl -p $pid -d $suite_dir

# Run test suites and determine bug detection
test_project_bug_detection $pid $suite_dir $suite_src $suite_num

# Run test suites and determine mutation score
test_mutation $pid $suite_dir

# Run test suites and determine code coverage
test_coverage $pid $suite_dir 0

rm -rf $gen_dir

echo $(( `date +%s` - start ))
