!!********************************************************************
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
    integer             :: nparmin
    double precision    :: u(2)
    double precision    :: Hi(3), H0, H1, H2

    nparmin = nint(par(1)) !nparmin compte le premier element

    IF (n.NE.4) THEN
        call printandstop('Error in hfun: wrong state dimension.')
    END IF
    IF (npar.lt.nparmin) THEN
        call printandstop('Error in hfun: wrong par dimension.')
    END IF

    call control(t,n,z,iarc,npar,par,u)
    call relevement(t,n,z,iarc,npar,par,Hi)

    H0 = Hi(1)
    H1 = Hi(2)
    H2 = Hi(3)

    H = H0 + u(1) * H1 + u(2) * H2

end subroutine hfun
