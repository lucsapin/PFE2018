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
    double precision :: p2, pzero, umax

    IF (n.NE.2) THEN
        call printandstop('Error in control: wrong state dimension.')
    END IF
    IF (npar.NE.7) THEN
        call printandstop('Error in control: wrong par dimension.')
    END IF

    umax    = par(7)

    pzero   = -1d0      ! variable duale associee au cout

    p2      = z(n+2)

    u       = -p2/pzero  ! u = p2

    if(abs(u).gt.umax)then
        u = sign(1d0,p2)*umax
    end if

end subroutine control
