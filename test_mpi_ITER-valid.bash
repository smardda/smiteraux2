#! /bin/bash --norc
set -e

# MPI version of the ITER-valid regression test.
# This script is used to test software parallelism using the
# Message Passing Interface (MPI).
# The number of MPI processes depends on how the script is executed.
# When run under Slurm, the number of processes is taken from SLURM_NTASKS.
# For direct execution, the number of processes is set by NPROC_LOCAL
# near the start of this script.
#
# Based on ITER-valid/case.bash for serial execution.
# See the serial script for details of the ITER case, validation references,
# antenna representation and provenance of the input data.
#
# The serial ITER-valid test runs GEOQ, HDSGEN and POWCAL separately from the 
# S/, G/, H/, and P/ directories.
#
# This script generates an equivalent ITER-valid MPI test case and runs
# the monolithic SMITER executable once from the top-level run directory
# ITER-valid_MPI:
#
# S/gshad.ctl G/top1barpart.ctl H/hdshad.ctl P/itertest1.ctl
#
# Control files .ctl are generated/copied from the existing ITER-valid case and 
# paths in .ctl files are adjusted where required for monolithic run.
# Geometry, equilibrium and auxiliary input files are linked into the top level
# ITER-valid_MPI directory.
#

# Script is intended to be run from smiteraux-full directory

# NPROC_LOCAL is the number of MPI processes for direct execution of this bash script.
# When running under Slurm, this value is ignored and SLURM_NTASKS is used
NPROC_LOCAL=4

if [[ -z "$HSAUX2" ]] ; then export HSAUX2=$PWD ; fi

#  ---- Test case ----
eqfile=EQX40.eqdsk
resfile=top1barpart.vtk
shadfile=vtkcomb.vtk

# Original serial case
serial_dir=$HSAUX2/ITER-valid

# MPI run directory
case_dir=ITER-valid_MPI
run_dir=$HSAUX2/$case_dir


# ---- Housekeeping -----

# Create directories from scratch for monolithic run of SMITER
rm -rf "$run_dir"
mkdir -p  "$run_dir"/{S,G,H,P}

# Shared test-deck data directories
equildir=$HSAUX2/Data/Equilibrium
geomdir=$HSAUX2/Data/Geometry
vtkdir=$HSAUX2/Data/VTK
miscdir=$HSAUX2/Data/Misc

INT=$SMITER_DIR/int

# scratch directory for script
tempdir=$PWD/ismtemp$$
mkdir $tempdir
echo "Logging in directory $tempdir"



# start MPI testing
echo "Executing MPI ITER-valid test in directory $run_dir"

cd $run_dir

# ----------------------------------------------------------------------
# Step 0.  Set up antenna file
# ----------------------------------------------------------------------
#
ln -sf $vtkdir/ant21.vtk

# convenient also to have these files linked in current dir for powcal 
ln -sf $miscdir/iteradn.txt
ln -sf $geomdir/iwall.txt wall.txt

# ----------------------------------------------------------------------
# Step 1. Combine files to make shadow
# ----------------------------------------------------------------------
# As in the serial ITER-valid case, vtktfm generates vtkcomb.vtk in the
# shared Data/Geometry directory
## panels are representation of ITER first wall, icrh_antenna_shadow is 3/4 of antenna
## icrh_antenna_observer is 1/4 top right of antenna (note biggest file by 10x)

pushd $vtkdir
$INT/cmdwrap $tempdir vtktfm vtkcomb
mv -f vtkcomb.vtk $geomdir
if [ $? -ne 0 ] ; then exit 1 ;fi
popd

# ----------------------------------------------------------------------
# Step 2. Copy CTLs from serial ITER-valid case
# ----------------------------------------------------------------------

cp $serial_dir/S/SHAD.ctl $run_dir/S
cp $serial_dir/G/RES.ctl $run_dir/G
cp $serial_dir/H/hdshad.ctl $run_dir/H
cp $serial_dir/P/itertest1.ctl $run_dir/P

# ----------------------------------------------------------------------
# Step 3. Generate S and G control files
# ----------------------------------------------------------------------
# SHAD.ctl is a template. As in the serial test, generate the case-specific 
# gshad.ctl

rm -f S/gshad.ctl
sed -e "s:SHAD:$shadfile:" -e "s:EQDSK:$eqfile:" \
    < S/SHAD.ctl > S/gshad.ctl

rm -f G/top1barpart.ctl
sed -e "s:RES:$resfile:" -e "s:EQDSK:$eqfile:" \
    < G/RES.ctl > G/top1barpart.ctl

#$INT/cmdwrap $tempdir geoq gshad
#if [ $? -ne 0 ] ; then exit 1 ;fi


# ----------------------------------------------------------------------
# Step 4. Adjust path for monolithic SMITER run from top-level directory
# ----------------------------------------------------------------------
# In the serial workflow HDSGEN runs from ITER-valid/H/ and 
# POWCAL from ITER-valid/P/
# SMITER instead runs from ITER-valid_MPI, so references in .ctl files to 
# files that are in S/ G/ and H must be relative to this top-level directory

sed -i \
  -e "s#\.\./S/#S/#g" -e "s#\./S/#S/#g" \
  -e "s#\.\./G/#G/#g" -e "s#\./G/#G/#g" \
  -e "s#\.\./H/#H/#g" -e "s#\./H/#H/#g"\
  -e "s#\.\./ant21\.vtk#ant21.vtk#g" \
  -e "s#\.\./iteradn\.txt#iteradn.txt#g" \
  H/hdshad.ctl P/itertest1.ctl


# ----------------------------------------------------------------------
# Step 5. Link geometry and equilibrium inputs locally
# ----------------------------------------------------------------------
ln -sf $equildir/$eqfile
ln -sf $geomdir/$shadfile
ln -sf $vtkdir/$resfile

# ----------------------------------------------------------------------
# Step 6. Set the Number of MPI processes and
#         select the MPI launcher
# ----------------------------------------------------------------------
# Under Slurm use the number of tasks allocated by the scheduler
#
if [[ -n "${SLURM_NTASKS}" ]]; then
    NPROC=$SLURM_NTASKS
    MPI_LAUNCH=mpirun
else
    NPROC=$NPROC_LOCAL
    MPI_LAUNCH=mpiexec
fi
echo "Using NP = $NPROC MPI processes"


# ----------------------------------------------------------------------
# Step 7. Run monolithic SMITER
# ----------------------------------------------------------------------

echo 
echo "Running SMITER..."
echo

$MPI_LAUNCH -np "$NPROC" smiter \
    S/gshad.ctl \
    G/top1barpart.ctl \
    H/hdshad.ctl \
    P/itertest1.ctl

echo "MPI ITER-valid test completed successfully"
echo "Script at end" $(date)
