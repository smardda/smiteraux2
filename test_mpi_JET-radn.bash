#! /bin/bash --norc
set -e

# MPI version of the JET-radn regression test.
# This script is used to test software parallelism using the
# Message Passing Interface (MPI).
#
# Based on JET-radn/case.bash for serial execution.
# It checks power conservation for radiation patterns in (R,Z) which 
# are circular, analytic in magnetic flux, or specified by an input data file.
# See the serial script for details of the JET-radn case setup, radiation
# sources, antenna representation and provenance of the input data.
#
# Serial workflow:
#   GEOQ (shadow geometry)  -> run once
#   GEOQ (results geometry) -> run once
#   HDSGEN                  -> run once
#   POWCAL                  -> run three times, using:
#
#       P/jone.ctl       circular radiation profile
#       P/jone_anal.ctl  analytic radiation profile in magnetic flux
#       P/jone_file.ctl  radiation profile specified by input data file
#
# MPI workflow:
#   The monolithic SMITER executable combines GEOQ, HDSGEN and POWCAL.
#   It is therefore run three times, once for each POWCAL control file:
#
#       S/jwallr360.ctl G/jone.ctl H/jwallr360.ctl P/jone.ctl
#       S/jwallr360.ctl G/jone.ctl H/jwallr360.ctl P/jone_anal.ctl
#       S/jwallr360.ctl G/jone.ctl H/jwallr360.ctl P/jone_file.ctl
# 
#
# The three MPI SMITER runs share the same S/, G/, H/ and P/ directories. The POWCAL
# stage results have different output prefixes (jone, jone_anal and jone_file),
# so they can be retained together in P/.
#
# Control files are copied/generated from the serial JET-radn case, 
# and relative paths are adjusted because SMITER is launched from the 
# top-level JET-radn_MPI directory.
#
# Because each SMITER invocation also reruns GEOQ and HDSGEN, generated
# S/G/H output files are removed between runs before the shared directories
# are reused.
#
# Geometry, equilibrium and auxiliary input files  required by SMITER
# are linked into the top-level JET-radn_MPI directory. The equilibrium
# file is also linked into the P/ directory for radiation-profile 
# post-processing with jradngnu.
#
# The script is intended to be run from the smiteraux-full directory.
#
# NPROC_LOCAL specifies the number of MPI processes for direct execution
# of this Bash script. When running under Slurm, SLURM_NTASKS is used instead.

NPROC_LOCAL=4

if [[ -z "$HSAUX2" ]] ; then export HSAUX2=$PWD ; fi

#  ---- Test case ----
eqfile=jet297.eqdsk
resfile=jwall1.vtk
shadfile=jwallr360.vtk

# Original serial case
serial_dir=$HSAUX2/JET-radn

# MPI run directory
case_dir=JET-radn_MPI
run_dir=$HSAUX2/$case_dir


# ---- Housekeeping -----
# Create the MPI run directory from scratch. 
rm -rf "$run_dir"
mkdir -p "$run_dir"/{S,G,H,P}

#  Shared test-deck data directories
equildir=$HSAUX2/Data/Equilibrium
geomdir=$HSAUX2/Data/Geometry
vtkdir=$HSAUX2/Data/VTK
miscdir=$HSAUX2/Data/Misc

# start MPI testing
echo "Executing MPI JET-radn test in directory $run_dir"

cd $run_dir


# ----------------------------------------------------------------------
# Step 0.  Set up antenna file and auxiliary input files
# ----------------------------------------------------------------------

ln -sf $vtkdir/ant11.vtk
ln -sf $miscdir/kprad_00224_6.txt
ln -sf $geomdir/jwall.txt wall.txt

# ----------------------------------------------------------------------
# Step 1.  Set up geometry
# ----------------------------------------------------------------------
# As in the serial JET-radn test, generate the axisymmetric JET geometry
# in the shared Data/Geometry directory.
(
    cd $geomdir
     ./jaxigeo.bash
)

# ----------------------------------------------------------------------
# Step 2. Copy control files from the serial JET-radn case
# ----------------------------------------------------------------------
cp "$serial_dir/S/SHAD.ctl"        "$run_dir/S"
cp "$serial_dir/G/RES.ctl"         "$run_dir/G"
cp "$serial_dir/H/jwallr360.ctl"   "$run_dir/H/"
cp "$serial_dir/P/jone.ctl"        "$run_dir/P"
cp "$serial_dir/P/jone_anal.ctl"   "$run_dir/P" 
cp "$serial_dir/P/jone_file.ctl"   "$run_dir/P"

# ----------------------------------------------------------------------
# Step 3. Generate S and G control files
# ----------------------------------------------------------------------
# The shadow geometry covers the full 360 degrees toroidally.
# The results geometry covers a 1-degree toroidal section.
rm -f S/jwallr360.ctl
sed -e "s:SHAD:$shadfile:" -e "s:EQDSK:$eqfile:" \
    < S/SHAD.ctl > S/jwallr360.ctl

rm -f G/jone.ctl
sed -e "s:RES:$resfile:" -e "s:EQDSK:$eqfile:" \
    < G/RES.ctl > G/jone.ctl


# ----------------------------------------------------------------------
# Step 4. Adjust paths for monolithic SMITER run from top-level directory
# ----------------------------------------------------------------------
# The monolithic SMITER is launched from the top-level JET-radn_MPI directory.
# Relative paths in the copied control files are adjusted.

sed -i \
    -e "s#\.\./S/#S/#g" -e "s#\./S/#S/#g" \
    -e "s#\.\./G/#G/#g" -e "s#\./G/#G/#g" \
    -e "s#\.\./H/#H/#g" -e "s#\./H/#H/#g"\
    -e "s#\.\./ant11\.vtk#ant11.vtk#g" \
    -e "s#\.\./kprad_00224_6\.txt#kprad_00224_6.txt#g" \
    H/jwallr360.ctl \
    P/jone.ctl \
    P/jone_anal.ctl \
    P/jone_file.ctl

# ----------------------------------------------------------------------
# Step 5. Link geometry, equilibrium and auxiliary input files locally
#         in the top-level JET-radn_MPI directory
# ----------------------------------------------------------------------
ln -sf $equildir/$eqfile
ln -sf $geomdir/$shadfile
ln -sf $geomdir/$resfile

# ----------------------------------------------------------------------
# Step 6. Set the number of MPI processes and select the MPI launcher
# ----------------------------------------------------------------------
# Under Slurm, use the number of tasks allocated by the scheduler and
# launch with mpirun. For direct execution, use NPROC_LOCAL and mpiexec.
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
# Step 7a. Circular radiation profile
# ----------------------------------------------------------------------
echo 
echo "Running SMITER: circular radiation profile..."
echo

$MPI_LAUNCH -np "$NPROC" smiter \
    S/jwallr360.ctl \
    G/jone.ctl \
    H/jwallr360.ctl \
    P/jone.ctl

# Generate the radiation-profile plot from the POWCAL result.
(
    cd P
    ln -sf $equildir/$eqfile 
    "$miscdir/jradngnu" jone 
     mv -f radn.ps radn_circ.ps
)


# ----------------------------------------------------------------------
# Step 7b. Radiation profile analytic in magnetic flux
# ----------------------------------------------------------------------

rm -f S/*.out G/*.out H/*.out

echo 
echo "Running SMITER: analytic radiation profile..."
echo

$MPI_LAUNCH -np "$NPROC" smiter \
    S/jwallr360.ctl \
    G/jone.ctl \
    H/jwallr360.ctl \
    P/jone_anal.ctl

# Generate the radiation-profile plot from the POWCAL result.
(
    cd P
    ln -sf $equildir/$eqfile 
    "$miscdir/jradngnu" jone_anal
    mv -f radn.ps radn_anal.ps
)

# ----------------------------------------------------------------------
# Step 7c. Radiation profile specified by an input data file
# ----------------------------------------------------------------------

rm -f S/*.out G/*.out H/*.out

echo 
echo "Running SMITER: file-input radiation profile..."
echo

$MPI_LAUNCH --oversubscribe -np "$NPROC" smiter \
    S/jwallr360.ctl \
    G/jone.ctl \
    H/jwallr360.ctl \
    P/jone_file.ctl

# Generate the radiation-profile plot from the POWCAL result.

(
    cd P
    ln -sf $equildir/$eqfile 
    "$miscdir/jradngnu" jone_file
    mv -f radn.ps radn_file.ps
)

echo
echo "MPI JET-radn test completed successfully"
echo "Script at end" $(date)


