!!----------------------------------------------------------------------
!>  \ingroup problemDefinition
!!  \brief Maximized Hamiltonian.
!!  \param[in] t    Time
!!  \param[in] n    State dimension
!!  \param[in] z    State and adjoint state at t
!!  \param[in] iarc Index of the current arc
!!  \param[in] npar Number of optional parameters
!!  \param[in] par  Optional parameters
!!
!!  \param[out] h   True Hamiltonian
!!  \attention      The vector par can be used for
!!                  constant values or homotopic parameters.
!!!
!!  \author Olivier Cots (INP-ENSEEIHT-IRIT)
!!  \date   2018
!!
Subroutine hfun(t,n,z,iarc,npar,par,h)
    implicit none
    integer,                           intent(in)  :: n,npar,iarc
    double precision,                  intent(in)  :: t
    double precision, dimension(2*n),  intent(in)  :: z
    double precision, dimension(npar), intent(in)  :: par
    double precision,                  intent(out) :: h

    external printandstop

    ! Local declarations
    double precision :: x, p, u, pzero

    IF (n.NE.1) THEN
        call printandstop('Error in control: wrong state dimension.')
    END IF
    IF (npar.NE.5) THEN
        call printandstop('Error in control: wrong par dimension.')
    END IF

    pzero   = -1d0 ! variable duale associee au cout

    x       = z(  1)
    p       = z(n+1)

    call control(t,n,z,iarc,npar,par,u)

    h       = p * (-x + u) + pzero * u**2 / 2d0

end subroutine hfun
