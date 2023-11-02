#include "SHELFICE_OPTIONS.h"

C--  File shelfice_forcing.F:
C--   Contents
C--   o SHELFICE_FORCING_T
C--   o SHELFICE_FORCING_S

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: SHELFICE_FORCING_T
C     !INTERFACE:
      SUBROUTINE SHELFICE_FORCING_RUNOFF_T(
     U                    gT_arr,
     I                    iMin,iMax,jMin,jMax, kLev, bi, bj,
     I                    myTime, myIter, myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | S/R SHELFICE_FORCING_T
C     | o Contains problem specific forcing for temperature.
C     *==========================================================*
C     | Adds terms to gT for forcing by shelfice sources
C     | e.g. heat flux
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
c#include "FFIELDS.h"
#include "SHELFICE.h"

C     !INPUT/OUTPUT PARAMETERS:
C     gT_arr    :: the tendency array
C     iMin,iMax :: Working range of x-index for applying forcing.
C     jMin,jMax :: Working range of y-index for applying forcing.
C     kLev      :: Current vertical level index
C     bi,bj     :: Current tile indices
C     myTime    :: Current time in simulation
C     myIter    :: Current iteration number
C     myThid    :: my Thread Id number
      _RL     gT_arr(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER iMin, iMax, jMin, jMax
      INTEGER kLev, bi, bj
      _RL     myTime
      INTEGER myIter
      INTEGER myThid

#ifdef ALLOW_SHELFICE
C     !LOCAL VARIABLES:
C     == Local variables ==
C     i,j   :: Loop counters
C     kp1,km1 :: index of next/previous level
C     gTloc   :: local tendency in boundary layer
C     drLoc   :: fractional cell width of boundary layer in (k+/-1)th layer
      INTEGER i, j
      INTEGER Kp1, Km1
      LOGICAL atGroundingLine
      _RS     drLoc
      _RL     gTloc
      _RL     rflux
      _RL     ploc
      _RL     b
      _RL     min_thick_cell
      CHARACTER*(MAX_LEN_MBUF) msgBuf
CEOP

      b  =  -7.61    _d -4
      min_thick_cell = 40.0
C--   Forcing term
      IF ( SHELFICEaddRunoff ) THEN
       DO j=1,sNy
        DO i=1,sNx

!!! to change: just take value of shelficeSubglFlux(i,j,bi,bj) given
!!! do not add unless we are at a grounding line        

         atGroundingLine = .FALSE.
         rflux = 0. _d 0
         IF (maskInC(i-1,j,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.
         IF (maskInC(i+1,j,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.
         IF (maskInC(i,j-1,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.
         IF (maskInC(i,j+1,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.

         IF (atGroundingLine) THEN
             rflux = shelficeSubglFlux(i,j,bi,bj)
             rflux = rflux * recip_rA(i,j,bi,bj)
         ENDIF

!         IF (rflux.ne.0.0) then
!          WRITE(msgBuf,'(A,I3,I3,I2,E10.2)') 
!     &     "GOT HERE SHELFICE_FORCING_RUNOFF_PTRACER, ",
!     &     i, j, kLev, rflux
!          CALL PRINT_MESSAGE( msgBuf, standardMessageUnit,
!     &                      SQUEEZE_RIGHT, myThid )
!         ENDIF

         ploc = ABS(R_Shelfice(i,j,bi,bj))

!!! ADD CLAUSE FOR klowc==1         

         IF (klev.eq.1 .and. kLev .EQ. kLowC(I,J,bi,bj)) THEN
          gTloc = rflux * (b * ploc  - theta(i,j,klev,bi,bj))
     &          /( drF(kLev)*_hFacC(I,J,kLev,bi,bj))
          gT_arr(i,j) = gT_arr(i,j) + gTloc
         ELSEIF ( kLev .GT. 1 .AND. kLev .EQ. kLowC(I,J,bi,bj) ) THEN
          km1 = MAX(kLev-1,1)
          drLoc = min_thick_cell - drF(kLev)*_hFacC(I,J,kLev,bi,bj) 
          drLoc = MIN( drLoc, drF(Km1) * _hFacC(I,J,Km1,bi,bj) )
          drLoc = MAX( drLoc, 0. _d 0)
          gTloc = rflux * (b * ploc  - theta(i,j,klev,bi,bj)) 
     &         /( drF(kLev)*_hFacC(I,J,kLev,bi,bj)+drLoc )
          gT_arr(i,j) = gT_arr(i,j) + gTloc
         ELSEIF ( kLev .LT. Nr .AND. kLev+1 .EQ. kLowC(I,J,bi,bj) ) THEN
          kp1 = MAX(kLev+1,1)
          drLoc = min_thick_cell - drF(kLev)*_hFacC(I,J,kp1,bi,bj) 
          drLoc = MIN( drLoc, drF(kLev) * _hFacC(I,J,kLev,bi,bj) )
          drLoc = MAX( drLoc, 0. _d 0)
          gTloc = rflux * (b * ploc - theta(i,j,klev+1,bi,bj))
     &         /( drF(kp1)*_hFacC(I,J,kp1,bi,bj)+drLoc )
          gT_arr(i,j) = gT_arr(i,j) + gTloc
     &         * drLoc*recip_drF(kLev)* _recip_hFacC(i,j,kLev,bi,bj)
         ENDIF
        ENDDO
       ENDDO
      ENDIF

#endif /* ALLOW_SHELFICE */
      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: SHELFICE_FORCING_S
C     !INTERFACE:
      SUBROUTINE SHELFICE_FORCING_RUNOFF_S(
     U                    gS_arr,
     I                    iMin,iMax,jMin,jMax, kLev, bi, bj,
     I                    myTime, myIter, myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | S/R SHELFICE_FORCING_S
C     | o Contains problem specific forcing for salt.
C     *==========================================================*
C     | Adds terms to gS for forcing by shelfice sources
C     | e.g. sal flux
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
c#include "FFIELDS.h"
#include "SHELFICE.h"

C     !INPUT/OUTPUT PARAMETERS:
C     gS_arr    :: the tendency array
C     iMin,iMax :: Working range of x-index for applying forcing.
C     jMin,jMax :: Working range of y-index for applying forcing.
C     kLev      :: Current vertical level index
C     bi,bj     :: Current tile indices
C     myTime    :: Current time in simulation
C     myIter    :: Current iteration number
C     myThid    :: my Thread Id number
      _RL     gS_arr(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      INTEGER iMin, iMax, jMin, jMax
      INTEGER kLev, bi, bj
      _RL     myTime
      INTEGER myIter
      INTEGER myThid

#ifdef ALLOW_SHELFICE
C     !LOCAL VARIABLES:
C     == Local variables ==
C     i,j   :: Loop counters
C     kp1,km1 :: index of next/previous level
C     gSloc   :: local tendency in boundary layer
C     drLoc   :: fractional cell width of boundary layer in (k+/-1)th layer
      INTEGER i, j
      INTEGER Kp1, Km1
      LOGICAL atGroundingLine
      _RS     drLoc
      _RL     gSloc
      _RL     rflux
      _RL     min_thick_cell
      CHARACTER*(MAX_LEN_MBUF) msgBuf
CEOP

      min_thick_cell = 40.0
C--   Forcing term
      IF ( SHELFICEaddRunoff ) THEN
       DO j=1,sNy
        DO i=1,sNx

!!! to change: just take value of shelficeSubglFlux(i,j,bi,bj) given
!!! do not add unless we are at a grounding line        

         atGroundingLine = .FALSE.
         rflux = 0. _d 0
         IF (maskInC(i-1,j,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.
         IF (maskInC(i+1,j,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.
         IF (maskInC(i,j-1,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.
         IF (maskInC(i,j+1,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.

         IF (atGroundingLine) THEN
             rflux = shelficeSubglFlux(i,j,bi,bj)
             rflux = rflux * recip_rA(i,j,bi,bj)
         ENDIF


!!! ADD CLAUSE FOR klowc==1         

         IF (klev.eq.1 .and. kLev .EQ. kLowC(I,J,bi,bj)) THEN
          gSloc = rflux * (0. _d 0  - salt(i,j,klev,bi,bj))
     &          /( drF(kLev)*_hFacC(I,J,kLev,bi,bj))
          gS_arr(i,j) = gS_arr(i,j) + gSloc
         ELSEIF ( kLev .GT. 1 .AND. kLev .EQ. kLowC(I,J,bi,bj) ) THEN
          km1 = MAX(kLev-1,1)
          drLoc = min_thick_cell - drF(kLev)*_hFacC(I,J,kLev,bi,bj) 
          drLoc = MIN( drLoc, drF(Km1) * _hFacC(I,J,Km1,bi,bj) )
          drLoc = MAX( drLoc, 0. _d 0)
          gSloc = rflux * (0. _d 0  - salt(i,j,klev,bi,bj)) 
     &         /( drF(kLev)*_hFacC(I,J,kLev,bi,bj)+drLoc )
          gS_arr(i,j) = gS_arr(i,j) + gSloc
         ELSEIF ( kLev .LT. Nr .AND. kLev+1 .EQ. kLowC(I,J,bi,bj) ) THEN
          kp1 = MAX(kLev+1,1)
          drLoc = min_thick_cell - drF(kLev)*_hFacC(I,J,kp1,bi,bj) 
          drLoc = MIN( drLoc, drF(kLev) * _hFacC(I,J,kLev,bi,bj) )
          drLoc = MAX( drLoc, 0. _d 0)
          gSloc = rflux * (0. _d 0 - salt(i,j,klev+1,bi,bj))
     &         /( drF(kp1)*_hFacC(I,J,kp1,bi,bj)+drLoc )
          gS_arr(i,j) = gS_arr(i,j) + gSloc
     &         * drLoc*recip_drF(kLev)* _recip_hFacC(i,j,kLev,bi,bj)
         ENDIF
        ENDDO
       ENDDO
      ENDIF

#endif /* ALLOW_SHELFICE */
      RETURN
      END

C---+----1----+----2----+----3----+----4----+----5----+----6----+----7-|--+----|
CBOP
C     !ROUTINE: SHELFICE_FORCING_S
C     !INTERFACE:
      SUBROUTINE SHELFICE_FORCING_RUNOFF_PTRACER(
     U                    gPtr_arr,
     I                    Ptr_arr,
     I                    Ptr_conc,
     I                    iMin,iMax,jMin,jMax, kLev, bi, bj,
     I                    myTime, myIter, myThid )

C     !DESCRIPTION: \bv
C     *==========================================================*
C     | S/R SHELFICE_FORCING_S
C     | o Contains problem specific forcing for salt.
C     *==========================================================*
C     | Adds terms to gS for forcing by shelfice sources
C     | e.g. sal flux
C     *==========================================================*
C     \ev

C     !USES:
      IMPLICIT NONE
C     == Global data ==
#include "SIZE.h"
#include "EEPARAMS.h"
#include "PARAMS.h"
#include "GRID.h"
#include "DYNVARS.h"
c#include "FFIELDS.h"
#include "SHELFICE.h"

C     !INPUT/OUTPUT PARAMETERS:
C     gPtr_arr    :: the tendency array
C     iMin,iMax :: Working range of x-index for applying forcing.
C     jMin,jMax :: Working range of y-index for applying forcing.
C     kLev      :: Current vertical level index
C     bi,bj     :: Current tile indices
C     myTime    :: Current time in simulation
C     myIter    :: Current iteration number
C     myThid    :: my Thread Id number
      _RL     gPtr_arr(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL     Ptr_arr(1-OLx:sNx+OLx,1-OLy:sNy+OLy)
      _RL     Ptr_conc
      INTEGER iMin, iMax, jMin, jMax
      INTEGER kLev, bi, bj
      _RL     myTime
      INTEGER myIter
      INTEGER myThid

#ifdef ALLOW_SHELFICE
C     !LOCAL VARIABLES:
C     == Local variables ==
C     i,j   :: Loop counters
C     kp1,km1 :: index of next/previous level
C     gPtrloc   :: local tendency in boundary layer
C     drLoc   :: fractional cell width of boundary layer in (k+/-1)th layer
      INTEGER i, j
      INTEGER Kp1, Km1
      LOGICAL atGroundingLine
      _RS     drLoc
      _RL     gPtrloc
      _RL     rflux
      _RL     min_thick_cell
      CHARACTER*(MAX_LEN_MBUF) msgBuf
CEOP

      min_thick_cell = 40.0
C--   Forcing term
      IF ( SHELFICEaddRunoff ) THEN
       DO j=1,sNy
        DO i=1,sNx

!!! to change: just take value of shelficeSubglFlux(i,j,bi,bj) given
!!! do not add unless we are at a grounding line        

         atGroundingLine = .FALSE.
         rflux = 0. _d 0
         IF (maskInC(i-1,j,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.
         IF (maskInC(i+1,j,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.
         IF (maskInC(i,j-1,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.
         IF (maskInC(i,j+1,bi,bj).eq.0 .and. 
     &       maskInC(i,j,bi,bj).eq.1) atGroundingLine=.TRUE.

         IF (atGroundingLine) THEN
             rflux = shelficeSubglFlux(i,j,bi,bj)
             rflux = rflux * recip_rA(i,j,bi,bj)
         ENDIF
        
!!! ADD CLAUSE FOR klowc==1         

         IF (klev.eq.1 .and. kLev .EQ. kLowC(I,J,bi,bj)) THEN
          gPtrloc = rflux * (ptr_Conc - ptr_arr(i,j))
     &          /( drF(kLev)*_hFacC(I,J,kLev,bi,bj))
          gPtr_arr(i,j) = gPtr_arr(i,j) + gPtrloc
         ELSEIF ( kLev .GT. 1 .AND. kLev .EQ. kLowC(I,J,bi,bj) ) THEN
          km1 = MAX(kLev-1,1)
          drLoc = min_thick_cell - drF(kLev)*_hFacC(I,J,kLev,bi,bj) 
          drLoc = MIN( drLoc, drF(Km1) * _hFacC(I,J,Km1,bi,bj) )
          drLoc = MAX( drLoc, 0. _d 0)
          gPtrloc = rflux * (ptr_Conc  - ptr_arr(i,j)) 
     &         /( drF(kLev)*_hFacC(I,J,kLev,bi,bj)+drLoc )
          gPtr_arr(i,j) = gPtr_arr(i,j) + gPtrloc
         ELSEIF ( kLev .LT. Nr .AND. kLev+1 .EQ. kLowC(I,J,bi,bj) ) THEN
          kp1 = MAX(kLev+1,1)
          drLoc = min_thick_cell - drF(kLev)*_hFacC(I,J,kp1,bi,bj) 
          drLoc = MIN( drLoc, drF(kLev) * _hFacC(I,J,kLev,bi,bj) )
          drLoc = MAX( drLoc, 0. _d 0)
          gPtrloc = rflux * (ptr_Conc - ptr_arr(i,j))
     &         /( drF(kp1)*_hFacC(I,J,kp1,bi,bj)+drLoc )
          gPtr_arr(i,j) = gPtr_arr(i,j) + gPtrloc
     &         * drLoc*recip_drF(kLev)* _recip_hFacC(i,j,kLev,bi,bj)
         ENDIF
        ENDDO
       ENDDO
      ENDIF

#endif /* ALLOW_SHELFICE */
      RETURN
      END
