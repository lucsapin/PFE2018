!!********************************************************************
!>  \ingroup problemDefinition
!!  \brief Shooting function.
!!  \param[in] ny       Shooting variable dimension
!!  \param[in] y        Shooting variable
!!  \param[in] npar     Number of optional parameters
!!  \param[in] par      Optional parameters
!!
!!  \param[out] s       Shooting value, same dimension as y
!!  \attention          The vector par can be used for constant values
!!                      or homotopic parameters.
!!
!!  \author Olivier Cots (INP-ENSEEIHT-IRIT)
!!  \date   2015-2016
!!
Subroutine sfun(ny,y,npar,par,s)
    use mod_exphv4sfun
    implicit none
    integer,                            intent(in)  :: ny
    integer,                            intent(in)  :: npar
    double precision,  dimension(ny),   intent(in)  :: y
    double precision,  dimension(npar), intent(in)  :: par
    double precision,  dimension(ny),   intent(out) :: s

    external printandstop

    !!  The user can call hfun and exphv subroutines inside sfun
    !!
    !!  hfun: code the maximized Hamiltonian
    !!
    !!      syntax: call hfun(t,n,z,iarc,npar,par,h)
    !!
    !!      see hfun.f90 for details.
    !!
    !!  exphv: computes the chronological exponential of the
    !!          Hamiltonian vector field hv defined by h.
    !!
    !!      syntax: call exphv(tspan,n,z0,iarc,npar,par,zf)
    !!
    !!       integer         , intent(in)    :: n, iarc, npar
    !!       double precision, intent(in)    :: tspan(:) = [t0 ... tf]
    !!       double precision, intent(in)    :: z0(2*n)
    !!       double precision, intent(in)    :: par(npar)
    !!       double precision, intent(out)   :: zf(2*n) = z(tf,t0,z0,par)
    !!

    ! Local declarations
    integer             :: nparmin, n, incs, iarc, choixpb
    double precision    :: pzero, z0(12), ham_0, tspan(2), zf(12), t0, tf
    double precision    :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
    double precision    :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
    double precision    :: Tmax, Isp, g0, muCR3BP, muSun, rhoSun, thetaS0, omegaS, m0, lambda, tf_par

    ! pour la conso min
    integer             :: nbarcTM, nnodes, i, j, incy
    double precision    :: tinit, tfina, delta_t, z1(12), ez0(12), Hi(4), H0, H1, H2, H3

    call getCoefficients(npar, par, nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                    q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                    Tmax, Isp, g0, muCR3BP, muSun, rhoSun, &
                                    thetaS0, omegaS, m0, lambda, choixpb, tf_par, pzero)

    if (choixpb.eq.0) then ! minimal time 

        n           = 6

        t0          = 0d0
        tf          = y(n+1)

        z0(1)       = q1_0
        z0(2)       = q2_0
        z0(3)       = q3_0
        z0(4)       = v1_0
        z0(5)       = v2_0
        z0(6)       = v3_0
        z0(n+1)     = y(1)
        z0(n+2)     = y(2)
        z0(n+3)     = y(3)
        z0(n+4)     = y(4)
        z0(n+5)     = y(5)
        z0(n+6)     = y(6)

        incs = 1

        ! H[t0] = -p0
        iarc = 1;
        call hfun(t0,n,z0(1:2*n),iarc,npar,par,ham_0)
        s(incs)  = ham_0 + pzero;   incs = incs + 1;

        !Integration
        tspan(1) = t0; tspan(2) = tf; iarc = 1; call exphv(tspan,n,z0(1:2*n),iarc,npar,par,zf(1:2*n));

        ! On doit atteindre la cible
        s(incs)  = zf(1) - q1_f; incs = incs + 1;
        s(incs)  = zf(2) - q2_f; incs = incs + 1;
        s(incs)  = zf(3) - q3_f; incs = incs + 1;
        s(incs)  = zf(4) - v1_f; incs = incs + 1;
        s(incs)  = zf(5) - v2_f; incs = incs + 1;
        s(incs)  = zf(6) - v3_f; incs = incs + 1;

    elseif (choixpb.eq.1) then ! minimal energy

        n           = 6

        t0          = 0d0
        tf          = 1d0

        z0(1)       = q1_0
        z0(2)       = q2_0
        z0(3)       = q3_0
        z0(4)       = v1_0
        z0(5)       = v2_0
        z0(6)       = v3_0
        z0(n+1)     = y(1)
        z0(n+2)     = y(2)
        z0(n+3)     = y(3)
        z0(n+4)     = y(4)
        z0(n+5)     = y(5)
        z0(n+6)     = y(6)

        incs = 1

        !Integration
        tspan(1) = t0; tspan(2) = tf; iarc = 1; call exphv(tspan,n,z0(1:2*n),iarc,npar,par,zf(1:2*n));

        ! On doit atteindre la cible
        s(incs)  = zf(1) - q1_f; incs = incs + 1;
        s(incs)  = zf(2) - q2_f; incs = incs + 1;
        s(incs)  = zf(3) - q3_f; incs = incs + 1;
        s(incs)  = zf(4) - v1_f; incs = incs + 1;
        s(incs)  = zf(5) - v2_f; incs = incs + 1;
        s(incs)  = zf(6) - v3_f; incs = incs + 1;

    end if

end subroutine sfun
