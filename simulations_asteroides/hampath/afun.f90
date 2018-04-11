!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
    Subroutine splitPar(npar, par,  nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                    q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                    Tmax, beta, muCR3BP, muSun, rhoSun, &
                                    thetaS0, omegaS, m0, lambda, choixpb, tf_par, min_dist_2_earth)
        implicit none
        integer,            intent(in)  :: npar
        double precision,   intent(in)  :: par(npar)
        double precision,   intent(out) :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
        double precision,   intent(out) :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
        double precision,   intent(out) :: Tmax, beta, muCR3BP, muSun, rhoSun
        double precision,   intent(out) :: thetaS0, omegaS, m0, lambda, tf_par, min_dist_2_earth
        integer, intent(out)            :: choixpb, nparmin

        !local variables
        integer :: i

        i       =  1;
        choixpb =  nint(par(i)) ; i = i + 1;

        if (choixpb.eq.0) then ! minimal time
            q1_0    =  par(i) ; i = i + 1;
            q2_0    =  par(i) ; i = i + 1;
            q3_0    =  par(i) ; i = i + 1;
            v1_0    =  par(i) ; i = i + 1;
            v2_0    =  par(i) ; i = i + 1;
            v3_0    =  par(i) ; i = i + 1;
            q1_f    =  par(i) ; i = i + 1;
            q2_f    =  par(i) ; i = i + 1;
            q3_f    =  par(i) ; i = i + 1;
            v1_f    =  par(i) ; i = i + 1;
            v2_f    =  par(i) ; i = i + 1;
            v3_f    =  par(i) ; i = i + 1;
            Tmax    =  par(i) ; i = i + 1;
            muCR3BP =  par(i) ; i = i + 1;
            muSun   =  par(i) ; i = i + 1;
            rhoSun  =  par(i) ; i = i + 1;
            thetaS0 =  par(i) ; i = i + 1;
            omegaS  =  par(i) ; i = i + 1;
            m0      =  par(i) ; i = i + 1;
            min_dist_2_earth =  par(i) ; i = i + 1;
            beta    =  0d0  ! dummy
            lambda  =  0d0  ! dummy
            tf_par  =  0d0  ! dummy
        elseif (choixpb.eq.1) then ! regularization tf min - conso min by barrier log
            q1_0    =  par(i) ; i = i + 1;
            q2_0    =  par(i) ; i = i + 1;
            q3_0    =  par(i) ; i = i + 1;
            v1_0    =  par(i) ; i = i + 1;
            v2_0    =  par(i) ; i = i + 1;
            v3_0    =  par(i) ; i = i + 1;
            q1_f    =  par(i) ; i = i + 1;
            q2_f    =  par(i) ; i = i + 1;
            q3_f    =  par(i) ; i = i + 1;
            v1_f    =  par(i) ; i = i + 1;
            v2_f    =  par(i) ; i = i + 1;
            v3_f    =  par(i) ; i = i + 1;
            Tmax    =  par(i) ; i = i + 1;
            muCR3BP =  par(i) ; i = i + 1;
            muSun   =  par(i) ; i = i + 1;
            rhoSun  =  par(i) ; i = i + 1;
            thetaS0 =  par(i) ; i = i + 1;
            omegaS  =  par(i) ; i = i + 1;
            m0      =  par(i) ; i = i + 1;
            min_dist_2_earth =  par(i) ; i = i + 1;
            beta    =  par(i) ; i = i + 1;
            lambda  =  par(i) ; i = i + 1;
            tf_par  =  0d0  ! dummy
        elseif (choixpb.eq.2) then ! minimal consumption with free tf
            q1_0    =  par(i) ; i = i + 1;
            q2_0    =  par(i) ; i = i + 1;
            q3_0    =  par(i) ; i = i + 1;
            v1_0    =  par(i) ; i = i + 1;
            v2_0    =  par(i) ; i = i + 1;
            v3_0    =  par(i) ; i = i + 1;
            q1_f    =  par(i) ; i = i + 1;
            q2_f    =  par(i) ; i = i + 1;
            q3_f    =  par(i) ; i = i + 1;
            v1_f    =  par(i) ; i = i + 1;
            v2_f    =  par(i) ; i = i + 1;
            v3_f    =  par(i) ; i = i + 1;
            Tmax    =  par(i) ; i = i + 1;
            muCR3BP =  par(i) ; i = i + 1;
            muSun   =  par(i) ; i = i + 1;
            rhoSun  =  par(i) ; i = i + 1;
            thetaS0 =  par(i) ; i = i + 1;
            omegaS  =  par(i) ; i = i + 1;
            m0      =  par(i) ; i = i + 1;
            min_dist_2_earth =  par(i) ; i = i + 1;
            beta    =  par(i) ; i = i + 1;
            lambda  =  0d0  ! dummy
            tf_par  =  0d0  ! dummy
        elseif (choixpb.eq.3) then ! minimal consumption with fixed tf (the time is normalized)
            q1_0    =  par(i) ; i = i + 1;
            q2_0    =  par(i) ; i = i + 1;
            q3_0    =  par(i) ; i = i + 1;
            v1_0    =  par(i) ; i = i + 1;
            v2_0    =  par(i) ; i = i + 1;
            v3_0    =  par(i) ; i = i + 1;
            q1_f    =  par(i) ; i = i + 1;
            q2_f    =  par(i) ; i = i + 1;
            q3_f    =  par(i) ; i = i + 1;
            v1_f    =  par(i) ; i = i + 1;
            v2_f    =  par(i) ; i = i + 1;
            v3_f    =  par(i) ; i = i + 1;
            Tmax    =  par(i) ; i = i + 1;
            muCR3BP =  par(i) ; i = i + 1;
            muSun   =  par(i) ; i = i + 1;
            rhoSun  =  par(i) ; i = i + 1;
            thetaS0 =  par(i) ; i = i + 1;
            omegaS  =  par(i) ; i = i + 1;
            m0      =  par(i) ; i = i + 1;
            min_dist_2_earth =  par(i) ; i = i + 1;
            beta    =  par(i) ; i = i + 1;
            lambda  =  0d0  ! dummy
            tf_par  =  par(i) ; i = i + 1;
        end if

        nparmin = i-1

    end Subroutine splitPar

!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
    Subroutine getCoefficients(npar, par,   nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                            q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                            Tmax, beta, muCR3BP, muSun, rhoSun, &
                                            thetaS0, omegaS, m0, lambda, choixpb, tf_par, &
                                            min_dist_2_earth, pzero)
        implicit none
        integer,            intent(in)  :: npar
        double precision,   intent(in)  :: par(npar)
        double precision,   intent(out) :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
        double precision,   intent(out) :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
        double precision,   intent(out) :: Tmax, beta, muCR3BP, muSun, rhoSun
        double precision,   intent(out) :: thetaS0, omegaS, m0, lambda, tf_par, min_dist_2_earth, pzero
        integer, intent(out)            :: nparmin, choixpb


        call splitPar(npar, par,    nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0,     &
                                    q1_f, q2_f, q3_f, v1_f, v2_f, v3_f,     &
                                    Tmax, beta, muCR3BP, muSun, rhoSun,  &
                                    thetaS0, omegaS, m0, lambda, choixpb, tf_par, min_dist_2_earth)

        pzero = -1d0

    End Subroutine getCoefficients

!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
!!  Les contraintes
!!
     Subroutine getConstDistEarth(t,n,z,iarc,npar,par,c)
        implicit none
        integer, intent(in)                             :: n,npar,iarc
        double precision, intent(in)                    :: t
        double precision, dimension(2*n),   intent(in)  :: z
        double precision, dimension(npar),  intent(in)  :: par
        double precision, dimension(5),     intent(out) :: c

        !Local declarations
        integer          :: nparmin, choixpb
        double precision :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
        double precision :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
        double precision :: Tmax, beta, mu, muSun, rhoSun, thetaS0, omegaS, m0, lambda, tf_par
        double precision :: r1, r2, thetaS, rS, q1, q2, q3, v1, v2, v3, pzero, min_dist_2_earth

        call getCoefficients(npar, par, nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                        q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                        Tmax, beta, mu, muSun, rhoSun,   &
                                        thetaS0, omegaS, m0, lambda, choixpb, tf_par, min_dist_2_earth, pzero)

        q1      = z(1)                                                                      ;
        q2      = z(2)                                                                      ;
        q3      = z(3)                                                                      ;
        v1      = z(4)                                                                      ;
        v2      = z(5)                                                                      ;
        v3      = z(6)                                                                      ;

        c(1) = min_dist_2_earth**2 - ( (q1-mu)**2 + q2**2 + q3**2 ) ! constraint
        c(2) = -2d0*(v1*(q1-mu)+v2*q2+v3*q3)                        ! derivative wrt time
        c(3) = -2d0*(q1-mu)                                         ! derivative wrt q
        c(4) = -2d0*q2
        c(5) = -2d0*q3

    end subroutine getConstDistEarth


!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
!! Les champs de vecteurs
!!
    Subroutine champs(t,n,z,iarc,npar,par,Fi)
        implicit none
        integer, intent(in)                             :: n,npar,iarc                      ;
        double precision, intent(in)                    :: t                                ;
        double precision, dimension(2*n),   intent(in)  :: z                                ;
        double precision, dimension(npar),  intent(in)  :: par                              ;
        double precision, dimension(n*5),   intent(out) :: Fi                               ;

        !Local declarations
        integer          :: nparmin
        integer          :: i, choixpb
        double precision :: f0(n), f1(n), f2(n), f3(n), f4(n)
        double precision :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
        double precision :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
        double precision :: Tmax, beta, mu, muSun, rhoSun, thetaS0, omegaS, m0, lambda, tf_par
        double precision :: r1, r2, thetaS, rS, q1, q2, q3, v1, v2, v3, pzero, min_dist_2_earth
        double precision :: m

        call getCoefficients(npar, par, nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                        q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                        Tmax, beta, mu, muSun, rhoSun,   &
                                        thetaS0, omegaS, m0, lambda, choixpb, tf_par, min_dist_2_earth, pzero)

        q1      = z(1)                                                                      ;
        q2      = z(2)                                                                      ;
        q3      = z(3)                                                                      ;
        v1      = z(4)                                                                      ;
        v2      = z(5)                                                                      ;
        v3      = z(6)                                                                      ;

        r1      = sqrt((q1+mu)**2   + q2**2 + q3**2);
        r2      = sqrt((q1-1+mu)**2 + q2**2 + q3**2);

        if((choixpb.eq.0).or.(choixpb.eq.1).or.(choixpb.eq.2)) then ! the time is not normalized
            thetaS  = thetaS0 + omegaS*t;
        elseif (choixpb.eq.3) then ! minimal consumption with fixed tf (the time is normalized)
            thetaS  = thetaS0 + omegaS*t*tf_par;
        endif

        rS      = sqrt((q1-rhoSun*cos(thetaS))**2 + (q2-rhoSun*sin(thetaS))**2 + q3**2);

        if (choixpb.eq.0) then  ! minimal time : x = (q1, q2, q3, v1, v2, v3)

            f0      = (/ v1, v2, v3,                                                                &
                         2d0*v2 + q1 - (1d0-mu)*(q1+mu)/r1**3   - mu*(q1-1d0+mu)/r2**3  -           &
                        (q1-rhoSun*cos(thetaS))*muSun/rS**3     - muSun*cos(thetaS)/rhoSun**2,      &
                        -2d0*v1 + q2 - (1d0-mu)*q2/r1**3        - mu*q2/r2**3           -           &
                        (q2-rhoSun*sin(thetaS))*muSun/rS**3     - muSun*sin(thetaS)/rhoSun**2,      &
                                     - (1d0-mu)*q3/r1**3        - mu*q3/r2**3   - q3*muSun/rS**3   /)

            f1      = (/ 0d0, 0d0, 0d0, Tmax/m0, 0d0, 0d0 /)
            f2      = (/ 0d0, 0d0, 0d0, 0d0, Tmax/m0, 0d0 /)
            f3      = (/ 0d0, 0d0, 0d0, 0d0, 0d0, Tmax/m0 /)
            f4      = 0d0

        elseif ((choixpb.eq.1).or.(choixpb.eq.2).or.(choixpb.eq.3)) then ! the mass is not constant
                                                    ! regularization tf min - conso min by barrier log
                                                    ! consumption: x = (q1, q2, q3, v1, v2, v3, m)

            m       = z(7)

            f0      = (/ v1, v2, v3,                                                                &
                         2d0*v2 + q1 - (1d0-mu)*(q1+mu)/r1**3   - mu*(q1-1d0+mu)/r2**3  -           &
                        (q1-rhoSun*cos(thetaS))*muSun/rS**3     - muSun*cos(thetaS)/rhoSun**2,      &
                        -2d0*v1 + q2 - (1d0-mu)*q2/r1**3        - mu*q2/r2**3           -           &
                        (q2-rhoSun*sin(thetaS))*muSun/rS**3     - muSun*sin(thetaS)/rhoSun**2,      &
                                     - (1d0-mu)*q3/r1**3        - mu*q3/r2**3   - q3*muSun/rS**3, 0d0   /)

            f1      = (/ 0d0, 0d0, 0d0, Tmax/m, 0d0, 0d0, 0d0 /)
            f2      = (/ 0d0, 0d0, 0d0, 0d0, Tmax/m, 0d0, 0d0 /)
            f3      = (/ 0d0, 0d0, 0d0, 0d0, 0d0, Tmax/m, 0d0 /)
            f4      = (/ 0d0, 0d0, 0d0, 0d0, 0d0, 0d0, -beta*Tmax /)

        end if

        i           = 1                                                                     ;
        Fi(i:i-1+n) = f0;   i = i + n;
        Fi(i:i-1+n) = f1;   i = i + n;
        Fi(i:i-1+n) = f2;   i = i + n;
        Fi(i:i-1+n) = f3;   i = i + n;
        Fi(i:i-1+n) = f4;   i = i + n;

    end subroutine champs

!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
!! Les relevements hamiltoniens
!!
    Subroutine relevement(t,n,z,iarc,npar,par,Hi)
        implicit none
        integer, intent(in)                             :: n,npar,iarc
        double precision, intent(in)                    :: t
        double precision, dimension(2*n),   intent(in)  :: z
        double precision, dimension(npar),  intent(in)  :: par
        double precision, dimension(5),     intent(out) :: Hi

        !Local declarations
        double precision    :: F(n*5), fi(n), p(n)
        integer             :: i, j, m

        !Nombre de champs de vecteurs
        m       = 5

        !Vecteur adjoint
        p       = z(n+1:2*n)

        !Les différents champs
        call champs(t,n,z,iarc,npar,par,F)

        !Les relèvements
        j = 1
        do i = 1,m
            fi  = F(j:j-1+n);
            j   = j + n;
            call ps(n, p, fi, Hi(i) )
        end do

    end subroutine relevement

    subroutine ps(n,u,v,res)
        implicit none
        integer, intent(in)             :: n
        double precision, intent(in)    :: u(n), v(n)
        double precision, intent(out)   :: res

        ! local variables
        integer :: i

        res = 0d0
        do i=1,n
            res = res + u(i)*v(i)
        end do

    end subroutine ps

!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
!! Le controle
!!
    Subroutine control(t,n,z,iarc,npar,par,u)
        implicit none
        integer, intent(in)                             :: n,npar,iarc
        double precision, intent(in)                    :: t
        double precision, dimension(2*n),   intent(in)  :: z
        double precision, dimension(npar),  intent(in)  :: par
        double precision, dimension(3),     intent(out) :: u

        !Local declarations
        integer             :: nparmin, choixpb
        double precision    :: Hi(5), H0, H1, H2, H3, H4, nphi, phi, pzero, alpha, psi
        double precision    :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
        double precision    :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
        double precision    :: Tmax, beta, muCR3BP, muSun, rhoSun, thetaS0, omegaS, m0, lambda, tf_par
        double precision    :: uiarc, min_dist_2_earth

        call getCoefficients(npar, par, nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                        q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                        Tmax, beta, muCR3BP, muSun, rhoSun, &
                                        thetaS0, omegaS, m0, lambda, choixpb, tf_par, min_dist_2_earth, pzero)

        call relevement(t,n,z,iarc,npar,par,Hi)
        H0 = Hi(1)
        H1 = Hi(2)
        H2 = Hi(3)
        H3 = Hi(4)
        H4 = Hi(5)

        nphi = sqrt(H1**2+H2**2+H3**2)

        u  = 0d0
        if (choixpb.eq.0) then ! minimal time

            u(1) = H1/nphi
            u(2) = H2/nphi
            u(3) = H3/nphi

        elseif (choixpb.eq.1) then ! regularization tf min - conso min by barrier log

            phi     = nphi + lambda*pzero + H4
            psi     = (phi+2d0*pzero*lambda*(1d0-lambda)+sqrt(phi**2+4d0*lambda**2*(1d0-lambda)**2))/(2d0*phi)
            u(1)    = psi*H1/nphi
            u(2)    = psi*H2/nphi
            u(3)    = psi*H3/nphi

        elseif ((choixpb.eq.2).or.(choixpb.eq.3)) then ! minimal consumption with free or fixed tf

            uiarc   = par(nparmin+iarc)
            select case (nint(uiarc))
                case (1)
                    u(1) = H1/nphi
                    u(2) = H2/nphi
                    u(3) = H3/nphi
                case (0)
                    u    = 0d0
                case default
                    call printandstop('Error control: invalid value in par for the control structure!');
            end select

        end if

    end subroutine control

!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
!! La fonction de commutation
!!
    Subroutine switchfun(t,n,z,iarc,npar,par,sf)
        implicit none
        integer, intent(in)                             :: n,npar,iarc
        double precision, intent(in)                    :: t
        double precision, dimension(2*n),   intent(in)  :: z
        double precision, dimension(npar),  intent(in)  :: par
        double precision,                   intent(out) :: sf

        !Local declarations
        integer             :: nparmin, choixpb
        double precision    :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
        double precision    :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
        double precision    :: Tmax, beta, muCR3BP, muSun, rhoSun, thetaS0, omegaS, m0, lambda, tf_par
        double precision    :: min_dist_2_earth, pzero
        double precision    :: Hi(5), H0, H1, H2, H3, H4, nphi

        call getCoefficients(npar, par, nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                        q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                        Tmax, beta, muCR3BP, muSun, rhoSun, &
                                        thetaS0, omegaS, m0, lambda, choixpb, tf_par, min_dist_2_earth, pzero)

        call relevement(t,n,z,iarc,npar,par,Hi)
        H0 = Hi(1)
        H1 = Hi(2)
        H2 = Hi(3)
        H3 = Hi(4)
        H4 = Hi(5)

        nphi = sqrt(H1**2+H2**2+H3**2)

        sf = 0d0
        !if ((choixpb.eq.2).or.(choixpb.eq.3)) then ! minimal consumption with free or fixed tf
            sf   = nphi + H4 + pzero
        !end if

    end subroutine switchfun
