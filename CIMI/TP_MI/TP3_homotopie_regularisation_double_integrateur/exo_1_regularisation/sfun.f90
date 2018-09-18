!!----------------------------------------------------------------------
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

    !local variables
    double precision :: z0(4), zf(4), tspan(2)
    integer          :: n, iarc

    IF (ny.NE.2) THEN
        call printandstop('Error in control: wrong state dimension.')
    END IF
    IF (npar.NE.8) THEN
        call printandstop('Error in control: wrong par dimension.')
    END IF

    ! y = p0

    n        = 2                ! Dimension de l'etat

    ! par = [t0 tf x1_0 x2_0 x1_f x2_f umax epsi]'
    tspan(1) = par(1)           ! t0
    tspan(2) = par(2)           ! tf

    z0(  1)  = par(3)           ! x1_0
    z0(  2)  = par(4)           ! x2_0
    z0(n+1)  = y(1)             ! p1_0
    z0(n+2)  = y(2)             ! p2_0

    iarc     = 1                ! il n'y a qu'un arc : cf tir simple

    call exphv(tspan,n,z0,iarc,npar,par,zf)

    s(1)     = zf(1) - par(5)   ! x1(tf) - x1_f
    s(2)     = zf(2) - par(6)   ! x2(tf) - x2_f

end subroutine sfun
