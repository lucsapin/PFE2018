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
    double precision :: p2, umax, pzero, psi

    IF (n.NE.2) THEN
        call printandstop('Error in control: wrong state dimension.')
    END IF
    IF (npar.NE.7) THEN
        call printandstop('Error in control: wrong par dimension.')
    END IF

    pzero   = -1d0
    umax    = par(7)
    p2      = z(n+2)

    psi     = abs(p2)+pzero

    if(abs(psi).gt.1d-12)then
        u       = sign(1d0,p2)*umax*0.5d0*(psi+abs(psi))/psi
    else
        u       = 0d0
    end if

end subroutine control
