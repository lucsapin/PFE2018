!!********************************************************************
!>  \ingroup problemDefinition
!!  \brief Monitoring during continuation. This function is called
!!          at each accepted homotopy step.
!!
!!  \param[in]       Niter    Number of iterations
!!  \param[in]       ny       Shooting variable dimension
!!  \param[in]       npar     Number of optional parameters
!!  \param[in,out]   irtrn    Flag : homotopy stop when irtrn < 0
!!                            Values from -1 to -10 are already assigned
!!                            Please choose values less than -11
!!
!!  \author Olivier Cots (INP-ENSEEIHT-IRIT)
!!  \date   2015
!!  \copyright Eclipse Public License
Subroutine mfun(Niter,ny,npar,irtrn)
    use mod_exphv4sfun
    implicit none
    integer, intent(in)     :: Niter, ny, npar
    integer, intent(inout)  :: irtrn

    !! ------------------------------------------------------------------------------
    !!
    !!  The user can call getPointsFromPath and exphv subroutines inside mfun
    !!
    !! ------------------------------------------------------------------------------
    !!
    !! getPointsFromPath: get the N last points from the path of zeros.
    !!
    !!      syntax: call getPointsFromPath(ny,npar,N,times,yShoots,pars)
    !!
    !!       integer         , intent(in)    :: ny
    !!       integer         , intent(in)    :: npar
    !!       integer         , intent(in)    :: N
    !!       double precision, intent(out)   :: time(N)
    !!       double precision, intent(out)   :: yShoot(ny,N)
    !!       double precision, intent(out)   :: pars(npar,N)
    !!
    !! ------------------------------------------------------------------------------
    !!
    !!  exphv: computes the chronological exponential of the
    !!          Hamiltonian vector field hv defined by h.
    !!
    !!      syntax: call exphv(tspan,n,z0,iarc,npar,par,z)
    !!
    !!       integer         , intent(in)    :: n
    !!       integer         , intent(in)    :: iarc
    !!       integer         , intent(in)    :: npar
    !!       double precision, intent(in)    :: tspan(:) = [t0, t1, ... tf]
    !!       double precision, intent(in)    :: z0(2*n)
    !!       double precision, intent(in)    :: par(npar)
    !!
    !!  Either
    !!
    !!       double precision, intent(out)   :: z(2*n) = z(tf)
    !!
    !!  Or
    !!
    !!       double precision, intent(out)   :: z(2*n,nt) = [z(t0), z(t1), ... z(tf)]
    !!
    !!  Remark: in each case, the integration is made on only one single arc.
    !!
    !! ------------------------------------------------------------------------------

    !local variables
    integer             :: np, i, j, structure, n, nsteps, iarc, cpt, incy
    double precision    :: times(1), ys(ny,1), pars(npar,1), par(npar), y(ny)
    double precision    :: tinit, tfina, z0(20), sf_ref, tspan(2), delta_t
    integer             :: nparmin, choixpb, nbarcTM, nnodes
    double precision    :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
    double precision    :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
    double precision    :: Tmax, beta, muCR3BP, muSun, rhoSun, thetaS0, omegaS, m0, lambda, tf_par
    double precision    :: min_dist_2_earth, pzero

    if(mod(Niter,10).eq.0)then

        np      = 1
        call getPointsFromPath(ny,npar,np,times,ys,pars)
        par     = pars(:,1)
        y       = ys(:,1)

        call getCoefficients(npar, par, nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                        q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                        Tmax, beta, muCR3BP, muSun, rhoSun, &
                                        thetaS0, omegaS, m0, lambda, choixpb, tf_par, &
                                        min_dist_2_earth, pzero)

        if ((choixpb.eq.2).or.(choixpb.eq.3)) then ! minimal consumption with free or fixed tf

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

                ! on teste si les instants sont bien ordonnees
                if(tinit-tfina.ge.0d0)then !Les ti ne sont plus tries
                    irtrn = -10-i
                end if

                if(irtrn.gt.-10)then

                    ! on calcule la fonction de switch en z0 (debut d'un arc) pour donner le signe de reference
                    call switchfun(tinit,n,z0(1:2*n),iarc,npar,par,sf_ref)

                    ! On calcule la trajectoire en chaque noeud et on teste s'il y a un changement de signe de la fonction de commutation
                    delta_t = (tfina - tinit) / dble(nnodes+1)
                    do j=1,nnodes+1
                        tspan(1) = tinit+dble(j-1)*delta_t; ! t0 du noeud courant
                        tspan(2) = tspan(1)+delta_t;        ! tf du noeud courant

                        ! on teste sur le noeud
                        nsteps = 100
                        call checkSignSwitchFun(sf_ref, tspan(1), tspan(2), nsteps, n, z0(1:2*n), iarc, npar, par, cpt)

                        if(cpt.gt.0)then ! la fonction de commutation a traverse 0
                            irtrn = 100*i-10*j-cpt
                        end if

                        ! on met a jour z0 sauf si on a atteint tf
                        if((i.ne.nbarcTM).or.(j.ne.nnodes+1))then
                            z0(1:2*n) = y(incy:incy+2*n-1); incy = incy + 2*n;
                        end if

                    end do

                end if

            end do

        end if

    end if

End Subroutine mfun

!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
subroutine checkSignSwitchFun(sf_ref, t0, tf, nsteps, n, z0, iarc, npar, par, cpt)
    use mod_exphv4sfun
        implicit none
        integer, intent(in)                             :: n,npar,iarc,nsteps
        double precision, intent(in)                    :: t0, tf, sf_ref
        double precision, dimension(2*n),   intent(in)  :: z0
        double precision, dimension(npar),  intent(in)  :: par
        integer,                            intent(out) :: cpt

        !local variables
        double precision :: tspan(nsteps+1), z(2*n,nsteps+1), sf, h
        integer :: i

        ! Calcul de tspan
        h = (tf-t0)/(dble(nsteps))
        do i = 1,nsteps+1
            tspan(i) = t0 + (i-1) * h
        end do
        call exphv(tspan,n,z0,iarc,npar,par,z)

        cpt = 0
        do i=1,nsteps+1
            call switchfun(tspan(i),n,z(:,i),iarc,npar,par,sf)
            if(sf*sf_ref.le.0d0 .and. abs(sf*sf_ref).gt.1d-10)then ! La fonction de commutation change de signe
                cpt = cpt + 1
            end if
        end do

end subroutine checkSignSwitchFun
