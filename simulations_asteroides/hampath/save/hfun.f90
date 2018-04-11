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
!!  \date   2009-2016
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
    integer             :: nparmin, choixpb
    double precision    :: u(3)
    double precision    :: Hi(4), H0, H1, H2, H3, pzero, nu
    double precision    :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
    double precision    :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
    double precision    :: Tmax, Isp, g0, muCR3BP, muSun, rhoSun, thetaS0, omegaS, m0, lambda, tf_par

    call getCoefficients(npar, par, nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                    q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                    Tmax, Isp, g0, muCR3BP, muSun, rhoSun, &
                                    thetaS0, omegaS, m0, lambda, choixpb, tf_par, pzero)

    call control(t,n,z,iarc,npar,par,u)
    call relevement(t,n,z,iarc,npar,par,Hi)

    H0  = Hi(1)
    H1  = Hi(2)
    H2  = Hi(3)
    H3  = Hi(4)

    H   = 0d0
    if (choixpb.eq.0) then ! minimal time

        H  = H0 + u(1) * H1 + u(2) * H2 + u(3) * H3

    elseif (choixpb.eq.1) then ! minimal energy

        H  = tf_par*(H0-(H1**2+H2**2+H3**2)/(4d0*pzero))
        !H  = tf_par * (H0 + u(1) * H1 + u(2) * H2 + u(3) * H3 + (u(1)**2+u(2)**2+u(3)**2) * pzero)

    end if

end subroutine hfun
