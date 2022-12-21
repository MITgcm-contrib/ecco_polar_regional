This simulation was conducted using MITgmc_66j. 

The complete code, input, and results can be found at https://zenodo.org/record/4898376#.Y6MMeC8Rpf0
If you would like to access code and input files for sensitivity experiments, please contact Mensah directly. jNote that some heavy input files are missing here!!

MITgcm model setup and output for "Dense water downslope flow and AABW production in a numerical model: sensitivity to horizontal and vertical resolution in the region off Cape Darnley Polynya" (Vigan Mensah, Yoshihiro Nakayama, Masakazu Fujii, Yoshifumi Nogi, and Kay I. Ohshima, Ocean Modelling, 2021).

(Contents)
Here it contains
- code.zip (code to run this simulation at 40m vertical, 2 km horizontal resolution)
- input.zip (input file required for this simulation at 40m vertical, 2 km horizontal resolution)
- run40m2km.zip (model output for the control run at 40m vertical resolution and 2 km horizontal resolution for year 2008)


(How to compile)
- 40m1km.zip: The directory include the code and input folders needed to compile and run the model with a 40m vertical, 1km horizontal resolution.


To run this simulation,

After unzipping all folders:
1) Create your work directory ( thereafter called “config”) within your MITgcm directory :
2) Copy “code” into “config”
3) Then, in the MITgcm directory run the following commands
> cd config
> mkdir build
> cd build
> ../../../tools/genmake2 -of ../../../tools/build_options/<your_option_file> -mpi -mods ../code/

(the -mpi is optional)
> make depend
> make 

4) copy the mitgcmuv file generated in build into the directory of your choice (input in our case)

(How to submit a job)
In input, the file run_omp_high_t1.pbs is used to submit a job for running simulation.
This file may need to be modified so the commands are in accordance with the commands accepted by your supercomputer.

(Note on forcing files)
The era_xx folder which contains the forcing file can be found under https://ecco.jpl.nasa.gov/drive/files/Version5/Alpha
The model user needs to change the path to the era_xx folder in the file input/data.exf

For more info please send an email to vmensah@lowtem.hokudai.ac.jp

