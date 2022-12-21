MITgcm model setup and output for "Development of adjoint-based ocean state estimation for the Amundsen and Bellingshausen Seas and ice shelf cavities using MITgcm/ECCO"
This simulation was conducted using MITgmc_66j. Complete code, input, and results can be found at
https://zenodo.org/record/4541036#.Y6MN-y8Rpf0 or https://ecco.jpl.nasa.gov/drive/files/ECCO2/LLC270/ABS_ADJOINT/results. Note that some heavy input files are missing here!!


(Contents)
Here it contains
code.zip (code to run this simulation)
input.zip (input file required for this simulation)
run478it20.zip (output of ocean state estimates for iteration 20)

(How to compile)
To run this simulation,
mkdir build
cd build
/nobackup/ynakaya2/MITgcm/tools/genmake2 -rootdir=/nobackup/ynakaya2/MITgcm -of ../code2/linux_amd64_ifort+mpi_ice_nas -mpi -mods ../code2/
make depend
make adall

(How to submit a job)
script_run470_mitgcmad.csh is used to submit a job for running simulation.
script_optim478 is used for optimization jobs.

For more info please send an email to Yoshihiro.Nakayama@lowtem.hokudai.ac.jp

