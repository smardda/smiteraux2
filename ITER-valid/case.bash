#! /bin/bash --norc
# run case to compare with ITER results in Brank et al https://doi.org/10.1016/j.nme.2021.101021
# Comparison files provided by Matic Brank in email of 2022/07/27, NB m instead of mm in CAD
# Note this uses a 21x21 representation of antenna 
eqfile=EQX40.eqdsk
resfile=top1barpart.vtk
shadfile=vtkcomb.vtk
## Housekeeping
# scratch directory for script
tempdir=$PWD/ismtemp$$
mkdir $tempdir
echo "Logging in directory $tempdir"
INT=$SMITER_DIR/int
if [[ -z "$HSAUX2" ]] ; then export HSAUX2=${PWD%/*} ; fi
#set up soft links to $HSAUX2 (usually smiteraux-full directory)
equildir=$HSAUX2/Data/Equilibrium
geomdir=$HSAUX2/Data/Geometry
vtkdir=$HSAUX2/Data/VTK
miscdir=$HSAUX2/Data/Misc
## Step 0. Set up antenna file
#pushd $geomdir
# produces 21x21 representation of antenna
#./spheregen.bash 21 21 ant21
#cp ant21.vtk $vtk/ant21.vtk
#popd
#if [ $? -ne 0 ] ; then
# pvbatch fails at v 5.10.1 as used by Ubuntu 22
# fix up if pvbatch fails
ln -sf $vtkdir/ant21.vtk
#if
# convenient also to have these files linked in current dir for powcal 
ln -sf $miscdir/iteradn.txt
ln -sf $geomdir/iwall.txt wall.txt
## Step 2. Combine files to make shadow
## panels are representation of ITER first wall, icrh_antenna_shadow is 3/4 of antenna
## icrh_antenna_observer is 1/4 top right of antenna (note biggest file by 10x)
pushd $vtkdir
$INT/cmdwrap $tempdir vtktfm vtkcomb
mv -f vtkcomb.vtk $geomdir
if [ $? -ne 0 ] ; then exit 1 ;fi
popd
cd S
## Step 3b.  Shadow geometry is vtkcomb.vtk
rm -f gshad.ctl
sed -e "s:SHAD:$shadfile:" -e "s:EQDSK:$eqfile:" < SHAD.ctl > gshad.ctl
ln -sf $equildir/$eqfile
ln -sf $geomdir/$shadfile
$INT/cmdwrap $tempdir geoq gshad
if [ $? -ne 0 ] ; then exit 1 ;fi
## Step 3c. Results geometry
# tiny corner of icrh_antenna_observer
cd ../G
rm -f top1barpart.ctl
sed -e "s:RES:$resfile:" -e "s:EQDSK:$eqfile:" < RES.ctl > top1barpart.ctl
ln -sf $equildir/$eqfile
ln -sf $vtkdir/$resfile
$INT/cmdwrap $tempdir geoq top1barpart
if [ $? -ne 0 ] ; then exit 1 ;fi
## Step 4. HDS generation
cd ../H
$INT/cmdwrap $tempdir hdsgen hdshad
if [ $? -ne 0 ] ; then exit 1 ;fi
## Step 5. Power deposition results as field radn in itertest1_powx.vtk
cd ../P
$INT/cmdwrap $tempdir powcal itertest1
if [ $? -ne 0 ] ; then exit 1 ;fi
echo "Script at end" $(date)
