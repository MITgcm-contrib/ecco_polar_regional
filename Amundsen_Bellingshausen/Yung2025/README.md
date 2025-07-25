# MITgcm Pine Island Glacier Model configurations and experiments

As used in paper "Stratified suppression of turbulence in an ice shelf basal melt parameterisation" by Claire K. Yung, Madelaine G. Rosevear, Adele K. Morrison, Andrew McC. Hogg, Yoshihiro Nakayama (2025) https://egusphere.copernicus.org/preprints/2024/egusphere-2024-3513/ in review at The Cryosphere

Processed model data available here: https://zenodo.org/records/16358346

Modified from Yoshihiro Nakayama's 2021 paper "Impact of Subglacial Freshwater Discharge on Pine Island Ice Shelf"
https://agupubs.onlinelibrary.wiley.com/doi/full/10.1029/2021GL093923
accompanying zenodo repository
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5183196.svg)](https://doi.org/10.5281/zenodo.5183196)

From the above repository, download the `input` folder and save it as the name `input-PIG`.

How to run: clone the MITgcm repository

MITgcm version is https://github.com/claireyung/MOM6/tree/CYv2

In the directory `verification`, save this folder. Then build the model using the following steps (works for gadi, may need a different optfile for a different machine)


To build, enter `build-R22-4Oct`:
```
module purge
module load intel-compiler
module load openmpi
module load netcdf
make CLEAN
./../../../../MITgcm/tools/genmake2 -mpi -mods=../code-R22-4Oct -optfile=linux_amd64_ifort_gadi
make depend
make -j 16
```
To run on gadi, enter run directory, symbolic link `mitgcmuv` into the directory, and submit job using payu
```
module use /g/data3/hh5/public/modules
module load conda/analysis3
payu run
```
Make sure to change config.yaml to correct run directory if making new runs

A 10 day run takes around 12 hours on 100 CPUs. 

----

Modifications from Nakayama et al. (2021) include using different melt parameterisations and different drag coefficients (see `data.shelfice`), as well as an updated MITgcm version (see above). They have also been modified to run on the NCI gadi machine.

The experiments are

- `original-run-R22_exe`: HJ99-neutral parameterisation and Cd = 0.0015 as in Nakayama et al 2021
- `run-R22-20Aug`: Cd = 0.0015, StratFeedback parameterisation
- `run-R22-MK18limlocal`: Cd = 0.0015, StratFeedback+MK18 limit parameterisation
- `original-run-R22_exe_tuned2`: HJ99-neutral parameterisation, tuned Cd = 0.004
- `run-R22-bigCd-20Aug`: StratFeedback parameterisation, tuned Cd = 0.0042 to match `original-run-R22_exe`
- `run-R22-bigCd-20Aug-tuned3`: StratFeedback parameterisation, tuned Cd = 0.0073
- `run-R22-MK18limlocal-tuned3`: StratFeedback+MK18 limit parameterisation, tuned Cd = 0.0057

