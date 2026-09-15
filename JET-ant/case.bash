#! /bin/bash --norc
## Produce plot of beq+rays "from" element(s) of antenna
## Housekeeping
# flag start
echo "Logging script use in directory $PWD"
if [[ -z "$HSAUX2" ]] ; then export HSAUX2=${PWD%/*} ; fi
#set up soft links to $HSAUX2 (usually smiteraux-full directory)
equildir=$HSAUX2/Data/Equilibrium
geomdir=$HSAUX2/Data/Geometry
vtkdir=$HSAUX2/Data/VTK
miscdir=$HSAUX2/Data/Misc
## Step 0. Option to set up antenna file using geofil
#pushd $geomdir
##produces 10x10 representation of antenna sphere
#geofil ant10
#cp ant10.vtk $vtkdir
ln -sf $vtkdir/ant10.vtk
## Step 1.  Copy files other than geometry from Data
cp  $geomdir/jwall.txt $equildir/jet297.eqdsk $miscdir/kprad_00224_6.txt .
## Step 2. Set up geometry and copy
(cd $geomdir; ./jdivgeo.bash)
ln -sf $geomdir/jdiv11.vtk
ln -sf $miscdir/jdiv11.gnu
## Step 3.  Run the test
antest jant > jant.out
#Analyse output dump 
ex jant.out << @@@@
/--elt---.*1/
+1,/--elt---/-1w! elt1.txt
/--elt---.*22/
+1,/--elt---/-1w! elt22.txt
q
@@@@
sed -i -e "s/r0,z0,r,z//" elt1.txt
sed -i -e "s/r0,z0,r,z//" elt22.txt
$miscdir/jantraygnu jant
#gnuplot << @@
#plot "jwall.txt" with lines notitle, "elt22.txt" using 1:2:(\$3-\$1):(\$4-\$2) with vectors nohead notitle
#set output "rays.ps"
#set terminal postscript enhanced color dashed dashlength 2 font "Helvetica,30" \
#  linewidth 3 size 6,7
#replot
#@@
## tidy up if uncommented
# rm -f jwall.txt jet297.eqdsk kprad_00224_6.txt jdiv11.vtk jant.log jant_* beq+rays.ps elt*.txt jant.out
echo "Script at end" $(date)
