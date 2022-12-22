This simulation was conducted using MITgmc_66j. Complete code, input, and results can be found at
https://ecco.jpl.nasa.gov/drive/files/ECCO2/High_res_PIG/PIG_only_200m

Note that some heavy input files are missing here!!

latlon_run23:CTRL
latlon_run24:Runoff
latlon_run25:2*Runoff
latlon_run26:10*Runoff
latlon_run27:50*Runoff

%How to build and run
mkdir build
./../../tools/genmake2 -of ../../../tools/build_options/linux_amd64_ifort+mpi_ice_nas -mpi -mods ../code/
make depend
make -j 16
cd ..

mkdir test
cd test
ln -sf ../input/* .
ln -sf /nobackup/hzhang1/forcing/era_xx_it50/ .
cp ../build/mitgcm_uv .
qsub latlon_run23.sh
