This simulation was conducted using MITgmc_65y. Note that some heavy input files are missing here!!
Complete code, input, and results can be found at
https://ecco.jpl.nasa.gov/drive/files/ECCO2/LLC1080_REG_AMS/run260

Monthly and daily outputs are also available (see ECCO Drive).
 1080_run260_2010_daily	
 1080_run260_2013_daily	
 1080_run260_2016_2018_daily

%Instruction for running 2001-2006 case described in Nakayama et al., 2018
%Regional simulation with Amundsen-Bellingshausen Sea domain with tracers
%MITgcmUV version:  checkpoint65y

mkdir build
cd build
../../../tools/genmake2 -of ../../../tools/build_options/linux_amd64_ifort+mpi_ice_nas -mpi -mods ../code/
make depend
make -j 16

mkdir 1080_run260
cd 1080_run260
cp ../input/* .
cp ../build/mitgcmuv .

cd ..
qsub run.pbs

(run.pbs)
#!/bin/csh
#PBS -l select=8:ncpus=28:model=bro
#PBS -q long
#PBS -l walltime=120:00:00
#PBS -j oe
##PBS -m abe

module load comp-intel/2015.0.090 mpi-sgi/mpt.2.12r23 netcdf/4.0
umask 027
cd $PBS_O_WORKDIR
limit stacksize unlimited

# cp input files
cd 1080_run108
mkdir diags

# To run 
mpiexec -np 224 ./mitgcmuv
