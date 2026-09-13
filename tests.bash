#! /bin/bash
# Assuming SMARDDA modules are installed and on executable path, 
# execute without using parallelism in the current directory, 
# the listed test cases:
for i in DEMO-double-null ITER-valid JET-ant JET-radn;do 
(cd $i;./case.bash)
done
