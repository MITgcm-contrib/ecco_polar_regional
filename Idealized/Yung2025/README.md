# MITgcm ISOMIP+ Model configurations and experiments

As used in paper "Stratified suppression of turbulence in an ice shelf basal melt parameterisation" by Claire K. Yung, Madelaine G. Rosevear, Adele K. Morrison, Andrew McC. Hogg, Yoshihiro Nakayama (2025) https://egusphere.copernicus.org/preprints/2024/egusphere-2024-3513/ in review at The Cryosphere

Processed model data available here: https://zenodo.org/records/16358346

Modified from Yoshihiro Nakayama's ISOMIP+ MITgcm submission for JPL (see https://egusphere.copernicus.org/preprints/2025/egusphere-2025-1942)

How to run: clone the MITgcm repository

MITgcm version is https://github.com/claireyung/MOM6/tree/CYv1

In the directory `verification`, save this folder. Then build the model using the following steps (works for gadi, may need a different optfile for a different machine)

To build, enter `build`:
```
module purge
module load intel-compiler
module load openmpi
module load netcdf
make CLEAN
 ./../../../../MITgcm/tools/genmake2 -mpi -rootdir=../../../../MITgcm -mods=../code/ -optfile=linux_amd64_ifort_gadi -ds
make depend
make -j 16
```
To run on gadi, enter run directory and symbollically link executable `mitgcmuv` into directory. Then do
```
module use /g/data3/hh5/public/modules
module load conda/analysis3
payu run
```
Make sure to change config.yaml to correct run directory if making new runs

Run time is approximately 20-30 minutes realtime on 20 cores for 1 year model time.

To combine `netcdf`
```
ln -s ../../../utils/python/MITgcmutils/scripts/gluemncbig .
./gluemncbig -o archive/output000/grid.nc archive/output000/grid.t0*.nc
./gluemncbig -o archive/output000/state.nc archive/output000/state.0000000000.t0*.nc
./gluemncbig -o archive/output000/shelfice_tave.nc archive/output000/shelfice_tave.0000000000.t0*.nc
./gluemncbig -o archive/output000/tave.nc archive/output000/tave.0000000000.t0*.nc
./gluemncbig -o archive/output000/phiHyd.nc archive/output000/phiHyd.0000000000.t0*.nc
./gluemncbig -o archive/output000/phiHydLow.nc archive/output000/phiHydLow.0000000000.t0*.nc
./gluemncbig -o archive/output000/shelfsnap.nc archive/output000/shelfsnap.0000000000.t0*.nc

```

Note 
- `J10` means ConstCoeff parameterisation and `R22` means StratFeedback parameterisation.
- `utide` means prescribed tidal velocity
- `ustarmin` means minimum friction velocity limit
- `convectivelimitlocal` means StratFeedback+MK18 parameterisation

All configs use advective scheme 77 rather than 33 due to problems with the advection scheme (see https://egusphere.copernicus.org/preprints/2025/egusphere-2025-1942/)

Binary input files can be made with `create_binary_files.ipynb`
