#! /bin/bash --norc
# run JET case to check power conservation
# Files to test out radiation patterns in (R,Z) which are
# circular, analytic in magnetic flux, and specified by input file
eqfile=jet297.eqdsk
resfile=jwall1.vtk
shadfile=jwallr360.vtk
## Housekeeping
# scratch directory for script
tempdir=$PWD/ismtemp$$
mkdir $tempdir
echo "Logging in directory $tempdir"
INT=$SMITER_DIR/int
if [[ -z "$HSAUX2" ]] ; then export HSAUX2=${PWD%/*} ; fi
#set up soft links to $HSAUX2 (usually smiteraux2 directory)
equildir=$HSAUX2/Data/Equilibrium
geomdir=$HSAUX2/Data/Geometry
vtkdir=$HSAUX2/Data/VTK
miscdir=$HSAUX2/Data/Misc
## Step 0. Set up antenna file
#pushd $geom
# produces 11x11 representation of antenna
#./spheregen.bash 11 11 ant11
#cp ant11.vtk $vtk/ant11.vtk
#popd
#if [ $? -ne 0 ] ; then
# pvbatch fails at v 5.10.1 as used by Ubuntu 22
# fix up if pvbatch fails
ln -sf $vtkdir/ant11.vtk
#if
# convenient also to have these files linked in current dir for powcal 
ln -sf $miscdir/kprad_00224_6.txt
ln -sf $geomdir/jwall.txt wall.txt
## Step 2. Set up geometry
(cd $geomdir; ./jaxigeo.bash)
## Step 3b.  Shadow geometry is full 360deg toroidal
cd S
rm -f jwallr360.ctl
sed -e "s:SHAD:$shadfile:" -e "s:EQDSK:$eqfile:" < SHAD.ctl > jwallr360.ctl
ln -sf $equildir/$eqfile
ln -sf $geomdir/$shadfile
$INT/cmdwrap $tempdir geoq jwallr360
if [ $? -ne 0 ] ; then exit 1 ;fi
## Step 3c. Results geometry is 1deg toroidal
cd ../G
rm -f jone.ctl
sed -e "s:RES:$resfile:" -e "s:EQDSK:$eqfile:" < RES.ctl > jone.ctl
ln -sf $equildir/$eqfile
ln -sf $geomdir/$resfile
$INT/cmdwrap $tempdir geoq jone
if [ $? -ne 0 ] ; then exit 1 ;fi
## Step 4. HDS generation
cd ../H
$INT/cmdwrap $tempdir hdsgen jwallr360
if [ $? -ne 0 ] ; then exit 1 ;fi
## Step 5. Power deposition results as field radn in jone_powx.vtk
cd ../P
# circular case
$INT/cmdwrap $tempdir powcal jone
if [ $? -ne 0 ] ; then exit 1 ;fi
# to use radiation data file, specify volsource_formula='file_input'
## Step 6 analysis
# Step 6a circular radiation profile
ln -sf $equildir/$eqfile
$INT/cmdwrap $tempdir $miscdir/jradngnu jone
mv -f radn.ps radn_circ.ps
# Step 6b radiation profile analytic in flux psi
$INT/cmdwrap $tempdir powcal jone_anal
if [ $? -ne 0 ] ; then exit 1 ;fi
$INT/cmdwrap $tempdir $miscdir/jradngnu jone_anal
mv -f radn.ps radn_anal.ps
# Step 6c use radiation data file kprad_00224_6.txt
$INT/cmdwrap $tempdir powcal jone_file
if [ $? -ne 0 ] ; then exit 1 ;fi
$INT/cmdwrap $tempdir $miscdir/jradngnu jone_file
mv -f radn.ps radn_file.ps
echo "Script at end" $(date)
