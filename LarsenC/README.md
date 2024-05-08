[![DOI](https://zenodo.org/badge/672878589.svg)](https://zenodo.org/badge/latestdoi/672878589)
# Supplementary code, data and model output for: _Ice-front retreat controls on ocean dynamics under Larsen C Ice Shelf, Antarctica_ 

This repository contains the necessary code and input data to reproduce the MITgcm model output presented in:

Poinelli, M., Nakayama, Y., Larour, E., Vizcaino, M., & Riva, R. (2023). Ice-front retreat controls on ocean dynamics under Larsen C Ice Shelf, Antarctica. _Geophysical Research Letters_, 50, e2023GL104588, https://doi.org/10.1029/2023GL104588
![image](https://github.com/MPoinelli/ecco_polar_regional/assets/23040762/3b6a50c0-521a-4786-bc7a-4a4b1888ad36)


By using these resources, researchers can replicate the results obtained in the study and further explore the findings.


You will find the following:
* `README.md`			: this file	code				
* `code`: mitgcm code
* `input_larsen06f`			: input files for control run run_larsen06f
* `input_iceberg06f`  : input files for iceberg run run_iceberg06f

You can find model output, and .bin files to run the model in the ECCO-drive repository https://ecco.jpl.nasa.gov/drive/files/ECCO2/High_res_LarsenC/:

If you find this material helpful, or if you use our code and data in your research, please cite our publication listed above.
Do not hesitate to send me an [email](mailto:mattia.poinelli@jpl.nasa.gov) if anything is unclear.

---
## Quick runme

0) Download a copy of this repository:

```bash
git clone https://github.com/MPoinelli/Poinelli2023b_GRL.git
```

1) Download a git-aware copy of [MITgcm](http://mitgcm.org)

```bash
git clone https://github.com/MITgcm/MITgcm.git
```

2) Select the folder where you want to compile MITgcm (assuming that you did NOT download MITgcm in the same directory of `Poinelli2023b_GRL`), e.g. a folder named `build` within the `MITgcm` directory:

Please note that MITgcm offers numerous option files and customization options. For detailed guidelines on how to use the software, please refer to the MITgcm user [manual](https://mitgcm.readthedocs.io/en/latest/index.html).

The experiments presented in this repository were conducted on the [NASA Pleiades](https://www.nas.nasa.gov/hecc/#url) supercomputer, utilizing 964 processors running for approximately 10 days per experiment.

To adapt the grid and time scale and/or grid resolution to your own machine, you may modify the relevant parameters as needed. Note that changing the resolution will likely alter the results.

```bash
mkdir MITgcm/build
MITgcm/tools/genmake2 -mods ../../Poinelli2023b_GRL/code -optfile </PATH/TO/OPTFILE>
make depend
make
```

3) Run MITgcm. If compilation finished successfully, then an executable called `mitgcmuv` will now exist in the local `build` folder. If you were to run the model as a single process, simply type:

```bash
cd Poinelli2023b_GRL/input_larsen06fx
ln -s ../MITgcm/build/mitgcmuv .
./mitgcmuv
```
However, as mentioned above, the experiments were designed to rely on parallel computing and were performed on the Pleiades supercomputer. 

Furthermore, you will need .bin files that are in here https://ecco.jpl.nasa.gov/drive/files/ECCO2/High_res_LarsenC/repository_bin_files.

Do not hesitate to send me an [email](mailto:mattia.poinelli@jpl.nasa.gov) if you need support with running these experiments in a parallel environment.
