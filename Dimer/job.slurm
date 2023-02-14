#!/bin/bash
#SBATCH --job-name=orca-test-job
#SBATCH --output=orca-test-job.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --time=24:00:00
#SBATCH --cluster=smp
​
cd $SBATCH_O_WORKDIR
module purge
module load gcc/4.8.5
module load openmpi/4.1.1
module load orca/5.0.0
​
# Copies over files
cp $SLURM_SUBMIT_DIR/*.inp $SLURM_SCRATCH
​
export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH
# Suppresses OpenFabrics (openib) absence nonfatal error.
export OMPI_MCA_btl_base_warn_component_unused=0
# Makes all error messages print.
export OMPI_MCA_orte_base_help_aggregate=0
​
# Runs ORCA energy calcualtion.
cd $SLURM_SCRATCH
$(which orca) *.inp
​
# Copies over all remaining files after ORCA calculation.
# Comment the line below if you only want the output file.
# cp $SLURM_SCRATCH/* $SLURM_SUBMIT_DIR
