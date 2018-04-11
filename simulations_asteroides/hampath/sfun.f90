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
    double precision    :: pzero, z0(20), ham, tspan(2), zf(20), t0, tf, t1, nu1, c1(5)
    double precision    :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
    double precision    :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
    double precision    :: Tmax, beta, muCR3BP, muSun, rhoSun, thetaS0
    double precision    ::  omegaS, m0, lambda, min_dist_2_earth, tf_par

    ! pour la conso min
    integer             :: nbarcTM, nnodes, i, j, incy
    double precision    :: tinit, tfina, delta_t, z1(20), ez0(20), Hi(5), H0, H1, H2, H3, H4, sw

    ! for debugging
    CHARACTER(len=120)  :: LINE
    integer             :: unitfileout, iost
    character(len=120)  :: nomfileout

    call getCoefficients(npar, par, nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                    q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                    Tmax, beta, muCR3BP, muSun, rhoSun, &
                                    thetaS0, omegaS, m0, lambda, choixpb, tf_par, min_dist_2_earth, pzero)

    if (choixpb.eq.0) then ! minimal time 

        n           = 6

        if(ny.eq.(n+1))then

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

            !Integration
            tspan(1) = t0; tspan(2) = tf; iarc = 1; call exphv(tspan,n,z0(1:2*n),iarc,npar,par,zf(1:2*n));

            ! On doit atteindre la cible
            s(incs)  = zf(1) - q1_f; incs = incs + 1;
            s(incs)  = zf(2) - q2_f; incs = incs + 1;
            s(incs)  = zf(3) - q3_f; incs = incs + 1;
            s(incs)  = zf(4) - v1_f; incs = incs + 1;
            s(incs)  = zf(5) - v2_f; incs = incs + 1;
            s(incs)  = zf(6) - v3_f; incs = incs + 1;

            ! H[tf] = -p0
            iarc = 1;
            call hfun(tf,n,zf(1:2*n),iarc,npar,par,ham)
            s(incs)  = ham + pzero;   incs = incs + 1;

        else    ! we have a touch point with the second order constraint getConstDistEarth
                ! y = (p0, tf, t1, nu1, z1)

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

            t1          = y(n+1+1);
            nu1         = y(n+1+2);
            incy        = n+1+3;
            z1(1:2*n)   = y(incy:incy+2*n-1); incy = incy + 2*n;

            incs        = 1

            ! getConstDistEarth(t1, z1) = 0
            iarc     = 1;
            call getConstDistEarth(t1,n,z1(1:2*n),iarc,npar,par,c1)
            s(incs)  = c1(1);   incs = incs + 1; ! c = 0
            s(incs)  = c1(2);   incs = incs + 1; ! touch point

            ! Integration sur le premier arc
            tspan(1) = t0; tspan(2) = t1; iarc = 1; call exphv(tspan,n,z0(1:2*n),iarc,npar,par,ez0(1:2*n));

            ! Matching with jump
            ez0(n+1) = ez0(n+1) - nu1 * c1(3);
            ez0(n+2) = ez0(n+2) - nu1 * c1(4);
            ez0(n+3) = ez0(n+3) - nu1 * c1(5);
            s(incs:incs+2*n-1)  = ez0(1:2*n) - z1(1:2*n); incs = incs + 2*n;

            ! Integration sur le sond arcs : iarc n'a pas d'importance car on a que des arcs non contraints
            tspan(1) = t1; tspan(2) = tf; iarc = 2; call exphv(tspan,n,z1(1:2*n),iarc,npar,par,zf(1:2*n));

            ! On doit atteindre la cible
            s(incs)  = zf(1) - q1_f; incs = incs + 1;
            s(incs)  = zf(2) - q2_f; incs = incs + 1;
            s(incs)  = zf(3) - q3_f; incs = incs + 1;
            s(incs)  = zf(4) - v1_f; incs = incs + 1;
            s(incs)  = zf(5) - v2_f; incs = incs + 1;
            s(incs)  = zf(6) - v3_f; incs = incs + 1;

            ! H[tf] = -p0
            iarc = 1;
            call hfun(tf,n,zf(1:2*n),iarc,npar,par,ham)
            s(incs)  = ham + pzero;   incs = incs + 1;

        end if

    elseif (choixpb.eq.1) then ! regularization tf min - conso min by barrier log

        n           = 7

        t0          = 0d0
        tf          = y(n+1)

        z0(1)       = q1_0
        z0(2)       = q2_0
        z0(3)       = q3_0
        z0(4)       = v1_0
        z0(5)       = v2_0
        z0(6)       = v3_0
        z0(7)       = m0
        z0(n+1)     = y(1)
        z0(n+2)     = y(2)
        z0(n+3)     = y(3)
        z0(n+4)     = y(4)
        z0(n+5)     = y(5)
        z0(n+6)     = y(6)
        z0(n+7)     = y(7)

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

        ! H[tf] = -(1d0-lambda)*p0
        iarc = 1;
        call hfun(tf,n,zf(1:2*n),iarc,npar,par,ham)
        s(incs)  = ham + (1d0-lambda)*pzero;   incs = incs + 1;

        ! pm(tf) = 0
        s(incs)  = zf(n+7); incs = incs + 1;

    elseif ((choixpb.eq.2).or.(choixpb.eq.3)) then ! minimal consumption with free or fixed tf

        ! y = (p0, t1, t2, ..., tf, z01, ..., z0N, z1, z11, ..., z1N, z2, z21, ..., z2N) % free tf
        ! or
        ! y = (p0, t1, t2, ...,     z01, ..., z0N, z1, z11, ..., z1N, z2, z21, ..., z2N) % fixed tf

        n           = 7

        nbarcTM     = npar-nparmin ! nombre d'arcs sur lesquels on fait du tir mutiple : ici tous
        if(choixpb.eq.2)then ! minimal consumption with free tf
            nnodes      = (ny-n-nbarcTM-(nbarcTM-1)*2*n)/(nbarcTM*2*n) ! nombres de noeuds de tir multiple
        elseif(choixpb.eq.3)then ! minimal consumption with fixed tf
            nnodes      = (ny-n-nbarcTM-1-(nbarcTM-1)*2*n)/(nbarcTM*2*n) ! nombres de noeuds de tir multiple
        end if

!        unitfileout = 11
!        nomfileout  = 'log.txt'
!        open(unit=unitfileout,file=trim(nomfileout),action="write",status="replace",iostat=iost)
!        if(iost.eq.0)then
!            WRITE (LINE,*) trim('nbarcTM'),' = ';
!            WRITE (unit=unitfileout,fmt='(a)'   ,advance='no') trim(LINE)
!            WRITE (unit=unitfileout,fmt='(i0.1)',advance='no') nbarcTM;
!            WRITE (unit=unitfileout,fmt='(a)'   ,advance='yes') ';'
!
!            WRITE (LINE,*) trim('nnodes'),' = ';
!            WRITE (unit=unitfileout,fmt='(a)'   ,advance='no') trim(LINE)
!            WRITE (unit=unitfileout,fmt='(i0.1)',advance='no') nnodes;
!            WRITE (unit=unitfileout,fmt='(a)'   ,advance='yes') ';'
!
!            WRITE (LINE,*) trim('nparmin'),' = ';
!            WRITE (unit=unitfileout,fmt='(a)'   ,advance='no') trim(LINE)
!            WRITE (unit=unitfileout,fmt='(i0.1)',advance='no') nparmin;
!            WRITE (unit=unitfileout,fmt='(a)'   ,advance='yes') ';'
!
!            close(unit=unitfileout)
!        end if

        do i=1,nbarcTM

            if(i.eq.1)then

                z0(1)       = q1_0
                z0(2)       = q2_0
                z0(3)       = q3_0
                z0(4)       = v1_0
                z0(5)       = v2_0
                z0(6)       = v3_0
                z0(7)       = m0
                z0(n+1)     = y(1)
                z0(n+2)     = y(2)
                z0(n+3)     = y(3)
                z0(n+4)     = y(4)
                z0(n+5)     = y(5)
                z0(n+6)     = y(6)
                z0(n+7)     = y(7)

                tinit       = 0d0
                tfina       = y(n+1) ! t1
                iarc        = 1

                if(choixpb.eq.2)then ! minimal consumption with free tf
                    incy        = n+nbarcTM  +1
                elseif(choixpb.eq.3)then ! minimal consumption with fixed tf
                    incy        = n+nbarcTM-1+1
                end if

                incs        = 1

            else

                tinit = tfina

                if(i.eq.nbarcTM)then ! we need to get tf
                    if(choixpb.eq.2)then ! minimal consumption with free tf
                        tfina = y(n+i)
                    elseif(choixpb.eq.3)then ! minimal consumption with fixed tf
                        tfina = 1d0 ! the time is normalized
                    end if
                else
                    tfina = y(n+i)
                end if

                iarc  = iarc + 1

            end if

            ! On calcule la trajectoire en chaque noeud et on fait le matching
            delta_t = (tfina - tinit) / dble(nnodes+1)
            do j=1,nnodes+1
                tspan(1) = tinit+dble(j-1)*delta_t;
                tspan(2) = tspan(1)+delta_t;
                call exphv(tspan,n,z0(1:2*n),iarc,npar,par,ez0(1:2*n));

                if((i.ne.nbarcTM).or.(j.ne.nnodes+1))then
                    z1(1:2*n)           = y(incy:incy+2*n-1);       incy = incy + 2*n;
                    s(incs:incs+2*n-1)  = ez0(1:2*n) - z1(1:2*n);   incs = incs + 2*n;
                    z0(1:2*n)           = z1(1:2*n);
                else
                    zf(1:2*n)           = ez0(1:2*n); ! on est en tf
                end if

            end do

            if(i.eq.nbarcTM) then ! on est en tf

                ! On doit atteindre la cible
                s(incs)  = zf(1) - q1_f; incs = incs + 1;
                s(incs)  = zf(2) - q2_f; incs = incs + 1;
                s(incs)  = zf(3) - q3_f; incs = incs + 1;
                s(incs)  = zf(4) - v1_f; incs = incs + 1;
                s(incs)  = zf(5) - v2_f; incs = incs + 1;
                s(incs)  = zf(6) - v3_f; incs = incs + 1;

                ! pm(tf) = 0
                s(incs)  = zf(n+7); incs = incs + 1;

                if(choixpb.eq.2)then ! minimal consumption with free tf
                    ! H[tf] = 0
                    call hfun(tfina,n,zf(1:2*n),iarc,npar,par,ham)
                    s(incs)  = ham;   incs = incs + 1;
                end if

            else ! on doit commuter

                call switchfun(tfina,n,z1,iarc,npar,par,sw)
                s(incs) = sw; incs = incs + 1; ! fonction de switch a zero

            end if


        end do

    end if

end subroutine sfun
