Subroutine hfun(t,n,z,iarc,npar,par,h)
    implicit none
    integer,                           intent(in)  :: n,npar,iarc
    double precision,                  intent(in)  :: t
    double precision, dimension(2*n),  intent(in)  :: z
    double precision, dimension(npar), intent(in)  :: par
    double precision,                  intent(out) :: h

    ! Local declarations
    double precision :: x,v,px,pv,lambda,u

    lambda  = par(7)
    x       = z(  1);   v   = z(  2)
    px      = z(n+1);   pv  = z(n+2)

    call control(t,n,z,iarc,npar,par,u)

    h = px*v + pv*(-lambda*v**2 + u) - 0.5d0*u**2

end subroutine hfun
