This simulation was conducted using MITgmc_66j. Complete code, input, and results can be found at
https://ecco.jpl.nasa.gov/drive/files/ECCO2/High_res_PIG/AMS_200m

%Results from Nakayama et al. 2019. 
%code, input, latlon_run8_tracer3_init2_cont_2/, tar file is also provided for one time download
%
%THIS IS UNDER DEVELOPMENT.PLEASE email Yoshihiro Nakayama for more information if you would like to use the folliwng results. 
%We also include new updated model results (still ongoing) with new model bathymetry. 
%Only 14 days of output after 30 days of spin-up. 
%Difference is model bathymetry
%latlon_run8_tracer3_init2_cont_4_for_all
%latlon_run8_tracer3_init2_cont_5_for_all (check this for the latest bathymetry run). 
%
%
%NOTE
%Other subroutines (matlab) needed are provided in latlon_run8_tracer3_init2_cont_2/
XC=rdmds('XC')% xaxis
YC=rdmds('YC')% yaxis
RC=rdmds('RC')% zaxis

time=8640;
  T=rdmds('T',time);
  S=rdmds('S',time);
  U=rdmds('U',time);
  V=rdmds('V',time);
  W=rdmds('W',time);
TR1=rdmds('PTRACER01',time);
TR2=-rdmds('PTRACER02',time);
Mflux=rdmds('SHICE_fwFlux',time);
icetopo=readbin('itopo_pierre2009.bin', [2016 768]);
pcolor(T(:,:,1,1)); caxis([-2 2])

DEPTH=readbin('topo_pierre2009_md.bin', [2016 768]);

TT=T(:,:,1,1)
scatter(XC(:),YC(:),3,TT(:)); caxis([-2 2]); 
