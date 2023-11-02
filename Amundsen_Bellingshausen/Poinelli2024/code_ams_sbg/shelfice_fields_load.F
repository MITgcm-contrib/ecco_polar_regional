#include "SHELFICE_OPTIONS.h"

CStartOfInterface
      SUBROUTINE SHELFICE_FIELDS_LOAD(
     I                            myTime, myIter, myThid )
C     *==========================================================*
C     | SUBROUTINE AIM_FIELDS_LOAD
C     | o Control reading of AIM fields from external source.
C     *==========================================================*
C     | Loads surface boundary condition datasets for AIM.
C     | The routine is called every timetep and periodically
C     | loads a set of external fields.
C     | Monthly climatology files are read either for
C     | a) a direct use (useMMsurfFc):
C     |   Albedo, Soil moisture, Surface Temperature
C     | b) time interpolation (useFMsurfBC):
C     |   Sea & Land surf. Temp, snow, sea-ice, soil-water (2-lev)
C     | + (1rst.iter) ground albedo, vegetation, land-sea fraction
C     | Most of the work is done by the master thread while
C     | the other threads spin (but all inside MDSIO S/R).
C     *==========================================================*
      IMPLICIT NONE

C     === Global variables ===
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "SHELFICE.h"



C     === Routine arguments ===
C     myTime :: Simulation time
C     myIter :: Simulation timestep number
C     myThid :: Thread no. that called this routine.
      _RL     myTime
      INTEGER myIter
      INTEGER myThid
CEndOfInterface

C     === Functions ===

#ifdef ALLOW_SHELFICE
#ifdef ALLOW_SHELFICE_TIMEDEP_FORCING
C     === Local variables ===
C     bi,bj, i,j  :: Loop counters
C     tYear       :: Fraction within year of myTime
C     mnthIndex   :: Current time in whole months
C     prevMnthIndex
C     fNam        :: Strings used in constructing file names
C     mnthNam
C     pfact       :: used to convert Pot.Temp. to in-situ Temp.
C     loadNewData :: true when need to load new data from file
      INTEGER bi,bj,i,j
c     _RL pfact
      LOGICAL first, changed
C--   for use with useMMsurfFc:
      CHARACTER*(MAX_LEN_FNAM) fNam

      INTEGER nm0, nm1, nmP
      _RL myRelTime, fac, tmpFac
      
C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

C--   find which month to use for surface BC
C     aim_surfForc_TimePeriod :: Length of forcing time period (e.g. 1 month)
C     aim_surfForc_NppCycle   :: Number of time period per Cycle (e.g. 12)

      myRelTime = myTime - startTime
      first = (myRelTime .lt. 0.5*deltaTClock)
      if ( shelfice_forcing_period .eq. 0.D0 ) THEN
!     &     .or. externForcingCycle .eq. 0.D0 ) then
C     control parameter is constant in time and only needs to be updated
C     once in the beginning
       changed = .false.
       nm0  = 1
       nm1  = 1
       fac     = 1.D0
      else

C--   Now calculate whether it is time to update the forcing arrays
       if (externForcingCycle .eq. 0.0 ) THEN
        CALL GET_PERIODIC_INTERVAL(
     O                   nmP, nm0, nm1, tmpFac, fac,
     I                   shelfice_extern_forcing_cycle, 
     I                   shelfice_forcing_period,
     I                   deltaTclock, 
     I                   myTime+0.5*shelfice_forcing_period, 
     I                   myThid )
        fac = 1.D0 - fac
       else
        CALL GET_PERIODIC_INTERVAL(
     O                   nmP, nm0, nm1, tmpFac, fac,
     I                   shelfice_extern_forcing_cycle, 
     I                   shelfice_forcing_period,
     I                   deltaTclock, myTime, 
     I                   myThid )
       endif

       IF ( nm0.NE.nmP ) THEN
        changed = .true.
       ELSE
        changed = .false.
       ENDIF
       IF ( first ) changed = .false.
      endif
 
      print *, "GOT HERE LOAD RUNOFF", nm0, nm1, fac

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|

C-     Load new data:

         
C-    Only one thread updates parameter in common block
C-    Wait for everyone to set loadNewData before Master updates prevMnthIndex
        _BARRIER

        IF ( first ) THEN

         IF ( ShelficeSubglFluxTimeDepFile .NE. ' '  ) THEN
          CALL READ_REC_XY_RL(ShelficeSubglFluxTimeDepFile,
     &                        shelficeSubglFlux1, 
     &                        nm0,myIter,myThid)
         ENDIF

C-      endif 1rst iter.
        ENDIF

        IF ( first .OR. changed) THEN

         DO bj=myByLo(myThid),myByHi(myThid)
          DO bi=myBxLo(myThid),myBxHi(myThid)
           DO j=1,sNy
            DO i=1,sNx
             shelficeSubglFlux0(i,j,bi,bj) = 
     &        shelficeSubglFlux1(i,j,bi,bj)
            ENDDO
           ENDDO
          ENDDO
         ENDDO

         IF ( ShelficeSubglFluxTimeDepFile .NE. ' '  ) THEN
          CALL READ_REC_XY_RL(ShelficeSubglFluxTimeDepFile,
     &                        shelficeSubglFlux1, 
     &                        nm1,myIter,myThid)
         ENDIF

C-      endif 1rst iter.
        ENDIF

        IF (SHELFICEaddrunoff) THEN
         DO bj=myByLo(myThid),myByHi(myThid)
          DO bi=myBxLo(myThid),myBxHi(myThid)
           DO j=1,sNy
            DO i=1,sNx

             shelficeSubglFlux (i,j,bi,bj) = 
     &         fac    * shelficeSubglFlux0(i,j,bi,bj)
     &      + (1-fac) * shelficeSubglFlux1(i,j,bi,bj)
            ENDDO
           ENDDO
          ENDDO
         ENDDO
        ENDIF

       _EXCH_XY_RL(shelficeSubglFlux, mythid )
        print *, "GOT HERE LOAD RUNOFF2", 
     &  myxgloballo, myygloballo,shelficeSubglFlux1(11,10,1,1)

#endif
#endif

      RETURN
      END
