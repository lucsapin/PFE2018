Subroutine sfun(ny,y,npar,par,s)
    use mod_exphv4sfun
    implicit none
    integer,                            intent(in)  :: ny
    integer,                            intent(in)  :: npar
    double precision,  dimension(ny),   intent(in)  :: y
    double precision,  dimension(npar), intent(in)  :: par
    double precision,  dimension(ny),   intent(out) :: s

    !local variables
    double precision :: z0(4), zf(4), tspan(2)
    integer          :: n, iarc

    n        = 2                ! Dimension of the state

    tspan(1) = par(1)           ! t0
    tspan(2) = par(2)           ! tf

    z0(  1)  = par(3)           ! x0
    z0(  2)  = par(4)           ! v0
    z0(n+1)  = y(1)             ! px0
    z0(n+2)  = y(2)             ! pv0

    iarc     = 1                ! There is only one arc:
                                !   compare with Bang-Bang case

    call exphv(tspan,n,z0,iarc,npar,par,zf)

    s(1)     = zf(1) - par(5)   ! x(tf) - xf
    s(2)     = zf(2) - par(6)   ! v(tf) - vf

end subroutine sfun
