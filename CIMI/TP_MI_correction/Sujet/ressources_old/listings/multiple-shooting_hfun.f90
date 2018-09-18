    lambda  = par(6)
    x       = z(  1); v       = z(  2)
    px      = z(n+1); pv      = z(n+2)

    call control(t,n,z,iarc,npar,par,u)

    h = px * v + pv * (-lambda*v**2 + u)
