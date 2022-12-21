This simulation was conducted using MITgmc_66j. Complete code, input, and results can be found at
https://ecco.jpl.nasa.gov/drive/files/ECCO2/LatLon_East_Antarctic

Note that some heavy input files are missing here!!

For quick download from ECCO drive, please look at https://ecco-group.org/docs/wget_download_multiple_files_and_directories.pdf.

Here, it contains the results of East Antarctic simulation from 1992-2016. Model grid is lat-lon similar to LLC1080 grid resolution roughly 3-4 km in the region. See Nakayama et al., submitted to GRL for detail. (2021/12/09).

To reproduce Nakayama et al. 2021 (GRL), please use code and input. Simulated output can be found inresults.

Regional ECCO-Darwin simulation for regional East Antarctic domain can be found in run 19. All ocean paramters remain the same and no difference between Nakayama et al., 2021 (results) and run 19.

%how to build and run
mkdir build
./../../tools/genmake2 -of ../../../tools/build_options/linux_amd64_ifort+mpi_ice_nas -mpi -mods ../code/
make depend
make -j 16
cd ..

mkdir test
cd test
ln -sf ../input/* .
ln -sf /nobackup/hzhang1/forcing/era_xx/ .
cp ../build/mitgcm_uv .
qsub run_omp_high_t1.pbs
