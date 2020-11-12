#!/bin/sh

size=${1:-64}
limit=${2:-1000}

rm *.smt2

echo "# Solver versions"
echo "boolector"
boolector --version

echo "yices"
yices-smt2 --version | head -n 1

echo "z3"
z3 --version

echo "cvc4"
cvc4 --version | head -n 1


echo ""
echo "Generating benchmark problems"
python gen.py $size $limit


echo ""
echo "# Multi benchmark"
for solver in "boolector" "yices-smt2" "z3"  "cvc4"
do
    echo $solver
    echo "" > $solver.multi.log
    { time for p in p*.smt2; do $solver $p >>$solver.multi.log; done; } 2> foo
    #somehow boolector finishes with a return value of 10 ... so I split the
    #line above in 2 separate statements
    t=$(cat foo | grep user | awk ' { print $2 }')
    echo "$t"
done

echo ""
echo "# Incremental benchmark"
for solver in "boolector --incremental" "yices-smt2 --incremental" "z3" "cvc4 --incremental"
do
    echo $solver
    { time $solver incremental.smt2 > $solver.incremental.log; } 2> foo
    t=$(cat foo | grep user | awk ' { print $2 }')
    echo "$t"
done


