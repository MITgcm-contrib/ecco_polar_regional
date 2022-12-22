#!/bin/bash
#PBS -N run_23
# This example uses the Sandy Bridge nodes
# User job can access ~31 GB of memory per Sandy Bridge node.
# A memory intensive job that needs more than ~1.9 GB
# per process should use less than 16 cores per node
# to allow more memory per MPI process. This example
# asks for 32 nodes and 8 MPI processes per node.
# This request implies 32x8 = 256 MPI processes for the job.
#PBS -q long
# queue: normal, debug, long, low, and devel (no more than 512 nodes)
#PBS -l select=5:ncpus=20:model=ivy
# model=[ san:16,30G/node; ivy:20,62G/node; has:24,122G/node]
#PBS -l walltime=12:00:00
#PBS -j oe
#PBS -m e

# load all modules needed
module load comp-intel/2016.2.181 mpi-sgi/mpt.2.14r19 hdf4/4.2.12 hdf5/1.8.18_mpt netcdf/4.4.1.1_mpt
module list
# By default, PBS executes your job from your home directory.
# However, you can use the environment variable
# PBS_O_WORKDIR to change to the directory where
# you submitted your job.

cd $PBS_O_WORKDIR
umask 22
# use of dplace to pin processes to processors may improve performance
# Here you request to pin processes to processors 4-11 of each Sandy Bridge node.
# For other processor types, you may have to pin to different processors.

# The resource request of select=32 and mpiprocs=8 implies
# that you want to have 256 MPI processes in total.
# If this is correct, you can omit the -np 256 for mpiexec
# that you might have used before.

mpiexec -v -np 100 ./mitgcmuv

# It is a good practice to write stderr and stdout to a file (ex: output)
# Otherwise, they will be written to the PBS stderr and stdout in /PBS/spool,
# which has limited amount  of space. When /PBS/spool is filled up, any job
# that tries to write to /PBS/spool will die.

# -end of script-
