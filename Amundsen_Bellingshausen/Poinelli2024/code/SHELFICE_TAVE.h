C $Header: /u/gcmpack/MITgcm/pkg/shelfice/SHELFICE_TAVE.h,v 1.4 2010/01/03 00:39:46 jmc Exp $
C $Name:  $

C     *==========================================================*
C     | SHELFICE_TAVE.h
C     | o Header for SHELFICE time-average output
C     *==========================================================*

#ifdef ALLOW_TIMEAVE

C     Keep track of time
      _RL SHELFICE_timeAve(nSx,nSy)
      COMMON /SHELFICE_TAVE_COUNT/ SHELFICE_timeAve

C     Storage arrays for time-averages
      _RL shelfice_heatFluxtave
     &     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,1,nSx,nSy)
      _RL shelfice_frshFluxtave
     &     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,1,nSx,nSy)
      _RL shelfice_thdrivetave
     &     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,1,nSx,nSy)
      _RL shelfice_sadrivetave
     &     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,1,nSx,nSy)
      _RL shelfice_fricveltave
     &     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,1,nSx,nSy)
      _RL shelfice_uloctave
     &     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,1,nSx,nSy)
      _RL shelfice_vloctave
     &     (1-OLx:sNx+OLx,1-OLy:sNy+OLy,1,nSx,nSy)

      COMMON /SHELFICE_TAVE_VARS/
     &     shelfice_heatFluxtave,
     &     shelfice_frshFluxtave,
     &     shelfice_thdrivetave,
     &     shelfice_sadrivetave,
     &     shelfice_fricveltave,
     &     shelfice_uloctave,
     &     shelfice_vloctave

#endif /* ALLOW_TIMEAVE */

CEH3 ;;; Local Variables: ***
CEH3 ;;; mode:fortran ***
CEH3 ;;; End: ***
