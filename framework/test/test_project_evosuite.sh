# Import helper subroutines and variables, and init Defects4J
source test.include
init

[ "$#" -eq 1 ] || die "usage: `basename "$0"` <project_name>"

pid=$1

# Directory for EvoSuite test suites
evo_dir=$TMP_DIR/evosuite

echo $evo_dir

suite_src=evosuite-branch
suite_num=1
suite_dir=$evo_dir/$pid/$suite_src/$suite_num


for bid in 1 3 5 7; do
    ./evosuite_runner.sh $pid $bid $evo_dir $suite_src $suite_num || echo "failed for bug: $bid"
done

# Fix all test suites
fix_test_suite.pl -p $pid -d $suite_dir

# Run test suites and determine bug detection
test_bug_detection $pid $suite_dir

# Run test suites and determine mutation score
#test_mutation $pid $suite_dir

# Run test suites and determine code coverage
#test_coverage $pid $suite_dir 0

rm -rf $evo_dir
