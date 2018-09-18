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
!!  \date   2018
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
    integer             :: nparmin, n, iarc
    double precision    :: z0(8), zf(8)
    double precision    :: tspan(2), pzero
    double precision    :: Hi(3), H0, H1, H2, hf
    double precision    :: t0, tf, x01, x02, x03, x04, mu, rf, gm, alpha

    nparmin = nint(par(1)) !nparmin compte le premier element

    IF (ny.NE.5) THEN
        call printandstop('Error in sfun: wrong shooting variable dimension.')
    END IF
    IF (npar.lt.nparmin) THEN
        call printandstop('Error in sfun: wrong par dimension.')
    END IF

    n           = 4
    pzero       = -1d0

    call getCoefficients(npar, par, x01, x02, x03, x04, mu, rf, gm)

    z0(1)       = x01
    z0(2)       = x02
    z0(3)       = x03
    z0(4)       = x04
    z0(n+1)     = y(1)
    z0(n+2)     = y(2)
    z0(n+3)     = y(3)
    z0(n+4)     = y(4)

    t0          = 0d0
    tf          = y(5)

    tspan(1)    = t0;
    tspan(2)    = tf;
    iarc        = 1;
    call exphv(tspan,n,z0,iarc,npar,par,zf);

    call hfun(tf,n,zf,iarc,npar,par,hf)

    alpha       = sqrt(mu/rf**3)

    s(1) = sqrt(zf(1)**2+zf(2)**2) - rf
    s(2) = zf(3) + alpha*zf(2)
    s(3) = zf(4) - alpha*zf(1)
    s(4) = hf + pzero
    s(5) = zf(2)*(zf(n+1)+alpha*zf(n+4)) - zf(1)*(zf(n+2)-alpha*zf(n+3))

end subroutine sfun
