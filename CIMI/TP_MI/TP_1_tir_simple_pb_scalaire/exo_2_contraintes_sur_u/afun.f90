!!----------------------------------------------------------------------
!>  \ingroup problemDefinition
!!  \brief Control.
!!  \param[in] t    Time
!!  \param[in] n    State dimension
!!  \param[in] z    State and adjoint state at t
!!  \param[in] iarc Index of the current arc
!!  \param[in] npar Number of optional parameters
!!  \param[in] par  Optional parameters
!!
!!  \param[out] u   Optimal control
!!  \attention      The vector par can be used for
!!                  constant values or homotopic parameters.
!!!
!!  \author Olivier Cots (INP-ENSEEIHT-IRIT)
!!  \date   2018
!!
Subroutine control(t,n,z,iarc,npar,par,u)
    implicit none
    integer,                           intent(in)  :: n,npar,iarc
    double precision,                  intent(in)  :: t
    double precision, dimension(2*n),  intent(in)  :: z
    double precision, dimension(npar), intent(in)  :: par
    double precision,                  intent(out) :: u

    ! variable locale
    double precision :: p, pzero, umax

    IF (n.NE.1) THEN
        call printandstop('Error in control: wrong state dimension.')
    END IF
    IF (npar.NE.5) THEN
        call printandstop('Error in control: wrong par dimension.')
    END IF

    umax    = par(5)
    pzero   = -1d0      ! variable duale associee au cout
    p       = z(n+1)
    u       = -p/pzero  ! u = p

!! DECOMMENTER
!
!    if(abs(u).gt.umax)then
!        u   = sign(1d0,p)*umax
!    end if
!
!! FIN DECOMMENTER

end subroutine control
