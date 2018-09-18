    n       = 2
    t0      = par(1); t1 = y(1); tf = y(2)
    z0(  1) = par(2); z0(  2) = par(3)  ! x0, v0
    z0(n+1) = y(3)  ; z0(n+2) = y(4)    ! px0, pv0
    z1      = y(5:8)

    ! Integration on the first arc: u = +1
    iarc    = 1; tspan   = (/t0, t1/)
    call exphv(tspan,n,z0,iarc,npar,par,expz0)

    ! Integration on the second arc: u = -1
    iarc    = 2; tspan   = (/t1, tf/)
    call exphv(tspan,n,z1,iarc,npar,par,expz1)

    call hfun(tf,n,expz1,iarc,npar,par,hf)

    s(1)    = expz1(1) - par(4) ! Final condition on xf
    s(2)    = expz1(2) - par(5) ! Final condition on vf
    s(3:6)  = z1 - expz0        ! Matching condition z1 = z(t1)
    s(7)    = expz0(n+2)        ! Switching condition pv(t1) = 0
    s(8)    = hf - 1d0          ! Final Hamiltonian condition
