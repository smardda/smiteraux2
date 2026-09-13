#!/bin/bash
#
# Slurm launcher for the JET-radn test case
#
# This script was written for the UKAEA Cumulus HPC cluster
#
# It allocates the HPC resources, loads the compiler/MPI environment,
# sets the SMARDDA environment and runs:
#
# test_mpi_JET-radn.bash
#
# The test script detects SLURM_NTASKS and uses the number of MPI tasks 
# allocated here.
#
# The module, partition, resource settings and SMROOT may need to be
# adapted for other HPC systems.
#

#SBATCH --job-name=JET-radn
#SBATCH --partition=cpu
#SBATCH --nodes=1
#SBATCH --ntasks=6
#SBATCH --ntasks-per-node=6
#SBATCH --cpus-per-task=1
##SBATCH --exclusive
#SBATCH --hint=nomultithread
#SBATCH --time=00:20:00
#SBATCH --output=%x_%j_1node_6tasks.out
#SBATCH --error=%x_%j_1node_6tasks.err

set -e

# Load the compiler/MPI toolchain
module purge
module load foss/2022a

echo "=== MODULE LOADED ==="

module list

echo "=== SLURM RESOURCES ==="
echo "Job started at: $(date)"
echo "Job id         : $SLURM_JOB_ID"
echo "Job name       : $SLURM_JOB_NAME"
echo "Nodelist       : $SLURM_NODELIST"
echo "Nodes          : $SLURM_JOB_NUM_NODES"
echo "NTASKS         : $SLURM_NTASKS"
echo "Tasks per node : $SLURM_NTASKS_PER_NODE"
echo "CPUs per task  : $SLURM_CPUS_PER_TASK"
echo "CPU bind       : $SLURM_CPU_BIND"
echo "========================"


# Set the SMARDDA environment for this test.
export SMROOT="$HOME/smardda"
export SMALIB_DIR="$SMROOT/smardda-lib"
export SMITER_DIR="$SMROOT/smardda-pfc-new"
export PATH="$SMITER_DIR/exec:$SMALIB_DIR/exec:$PATH"
export HSAUX="$SMITER_DIR/smiteraux"

echo "===  SMARDDA environment variables ==="
echo "SMROOT     = $SMROOT"
echo "SMALIB_DIR = $SMALIB_DIR"
echo "SMITER_DIR = $SMITER_DIR"
echo "HSAUX      = $HSAUX"

cd "$HSAUX"

echo "Current directory: $(pwd)"

echo "Running test_mpi_JET-radn.bash..."
bash ./test_mpi_ITER_valid.bash

echo "=========================================="
echo "Job finished at: $(date)"
echo "=========================================="