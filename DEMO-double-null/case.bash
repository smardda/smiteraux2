#! /bin/bash --norc
# run DEMO case for double null set up
eqfile1=nf6m_CQ2.eqdsk
eqfile2=nf6m_CQ2_upside_down.eqdsk
resfile=dwall1.vtk
shadfile=dwallr360.vtk
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
## Step 2. Set up geometry
(cd $geomdir; ./daxigeo.bash)
## Step 3b.  Shadow geometry is full 360deg toroidal
cd S
rm -f dwallr360.ctl
sed -e "s:SHAD:$shadfile:" -e "s:EQDSK:$eqfile1:" < SHAD.ctl > dwallr360.ctl
ln -sf $equildir/$eqfile1
ln -sf $geomdir/$shadfile
$INT/cmdwrap $tempdir geoq dwallr360
if [ $? -ne 0 ] ; then exit 1 ;fi
#
cd ../S_upside_down
rm -f dwallr360.ctl
sed -e "s:SHAD:$shadfile:" -e "s:EQDSK:$eqfile2:" < SHAD.ctl > dwallr360.ctl
ln -sf $equildir/$eqfile2
ln -sf $geomdir/$shadfile
$INT/cmdwrap $tempdir geoq dwallr360
if [ $? -ne 0 ] ; then exit 1 ;fi
#
## Step 3c. Results geometry is 1deg toroidal
cd ../G
rm -f powd.ctl
sed -e "s:RES:$resfile:" -e "s:EQDSK:$eqfile1:" < RES.ctl > powd.ctl
ln -sf $equildir/$eqfile1
ln -sf $geomdir/$resfile
$INT/cmdwrap $tempdir geoq powd
if [ $? -ne 0 ] ; then exit 1 ;fi
#field diagnostics
ln -sf $geomdir/dwall.txt wall.txt
$miscdir/dgeoqgnu powd &> /dev/null
#
cd ../G_upside_down
rm -f powd.ctl
sed -e "s:RES:$resfile:" -e "s:EQDSK:$eqfile2:" < RES.ctl > powd.ctl
ln -sf $equildir/$eqfile2
ln -sf $geomdir/$resfile
$INT/cmdwrap $tempdir geoq powd
if [ $? -ne 0 ] ; then exit 1 ;fi
#field diagnostics
ln -sf $geomdir/dwall.txt wall.txt
$miscdir/dgeoqgnu powd &> /dev/null
## Step 4. HDS generation
cd ../H
$INT/cmdwrap $tempdir hdsgen dwallr360
if [ $? -ne 0 ] ; then exit 1 ;fi
cd ../H_upside_down
$INT/cmdwrap $tempdir hdsgen dwallr360
if [ $? -ne 0 ] ; then exit 1 ;fi
## Step 5. powcal equivalent double null case
cd ../P
$INT/cmdwrap $tempdir powcal exp
if [ $? -ne 0 ] ; then exit 1 ;fi
$INT/cmdwrap $tempdir powcal exp-double
if [ $? -ne 0 ] ; then exit 1 ;fi
$INT/cmdwrap $tempdir powcal eich
if [ $? -ne 0 ] ; then exit 1 ;fi
#
cd ../P_upside_down
$INT/cmdwrap $tempdir powcal eich
if [ $? -ne 0 ] ; then exit 1 ;fi
$INT/cmdwrap $tempdir powcal exp-double
if [ $? -ne 0 ] ; then exit 1 ;fi
$INT/cmdwrap $tempdir powcal exp
if [ $? -ne 0 ] ; then exit 1 ;fi
$INT/cmdwrap $tempdir powcal exp-inboard
if [ $? -ne 0 ] ; then exit 1 ;fi
$INT/cmdwrap $tempdir powcal exp-outboard
if [ $? -ne 0 ] ; then exit 1 ;fi
echo "Script at end" $(date)	       
