#! /bin/bash
# Assuming SMARDDA modules are installed and on executable path, 
# execute without using parallelism in the current directory, 
# the listed test cases:
for i in DEMO-double-null ITER-valid JET-ant JET-radn;do 
echo "******Start of Case name "$i
(cd $i;./case.bash)
done
if [ $? -ne 0 ] ; then exit 1 ;fi
#  Create tar file containing power deposition results
tar cvf smiteraux2.tar $(find . -name "*_powx.vtk")
