##2022/05/07 created by Shuntaro Hyogo
This is updated version from Nakayama et al., 2018 (run260).

This simulation was conducted using MITgmc_66j. Note that some heavy input files are missing here!!
Complete code, input, and results can be found at
https://ecco.jpl.nasa.gov/drive/files/ECCO2/LLC1080_REG_AMS/Hyogo_et_al_2022/

<Changes from run260 to this model>
This is improved version of run260 with 70 vertical layers.
To adjust melt rate of the George VI ices shelf, we change the values of heat transfer coefficient TTT similar to run260.

Note that in this configuration, velocity, AngleSN, and AngleCN are rotated by 90 degrees. The grid uses a latitude-longitude grid north of  and a bipolar grid south of .
You need to covert like this below for using velocity (See in detail, http://mailman.mitgcm.org/pipermail/mitgcm-support/2014-January/008797.html).
The model output includes fields of sin and cos of the angle that the model grid north forms locally with geographical north. These are called AngleCS, AngleSN (cos(phi) and sin(phi), where phi \
is the angle).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%example for matlab user how to read the data
%for finding straightforward velocity
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath /Users/hyogo/MITgcm/utils/matlab/cs_grid/read_cs/
addpath /Users/hyogo/MITgcm/utils/matlab/cs_grid/
addpath /Users/hyogo/MITgcm/utils/matlab/

cd /Volumes/HDD_ABScl/model/ABSmodel_climBC/input
XC=rdmds('XC');% xaxis
YC=rdmds('YC');% yaxis
RC=rdmds('RC');% zaxis
RC=-squeeze(RC);
AngleSN=rdmds('AngleCS');
AngleCS=-rdmds('AngleSN');
TSUVW=rdmds('/Volumes/HDD_ABS2/data/Monthly_ABS_Hyogo_etal/TSUVW/state_3d_set2',17856);
T =TSUVW(:,:,:,1);
S =TSUVW(:,:,:,2);
Un=TSUVW(:,:,:,3);
Vn=TSUVW(:,:,:,4);
uc= Vn;
vc=-Un;
eastward_U=AngleCS.*uc-AngleSN.*vc; % eastward velocity
northward_V=AngleCS.*vc+AngleSN.*uc; %northward velocity


pcolor(T(:,:,1,1)); caxis([-2 2]); shading interp
pcolor(S(:,:,1,1)); caxis([32 34]); shading interp
pcolor(eastward_U(:,:,1,1)); caxis([-0.5 0.5]); shading interp
pcolor(northward_V(:,:,1,1)); caxis([-0.5 0.5]); shading interp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

##how to build and run
mkdir build
./../../tools/genmake2 -of ../../../tools/build_options/linux_amd64_ifort+mpi_ice_nas_tokyo3 -mpi -mods ../code/
make depend
make -j 16
cd ..
