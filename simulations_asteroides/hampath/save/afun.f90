!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
    Subroutine splitPar(npar, par,  nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                    q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                    Tmax, Isp, g0, muCR3BP, muSun, rhoSun, &
                                    thetaS0, omegaS, m0, lambda, choixpb, tf_par)
        implicit none
        integer,            intent(in)  :: npar
        double precision,   intent(in)  :: par(npar)
        double precision,   intent(out) :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
        double precision,   intent(out) :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
        double precision,   intent(out) :: Tmax, Isp, g0, muCR3BP, muSun, rhoSun
        double precision,   intent(out) :: thetaS0, omegaS, m0, lambda, tf_par
        integer, intent(out)            :: choixpb, nparmin

        !local variables
        integer :: i

        !parBocop    = [q0; qf; Tmax; Isp; g0; muCR3BP; muSun; rhoSun; thetaS0; omegaS; m0]

        i       =  1;
        nparmin =  nint(par(i)) ; i = i + 1;
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
            Isp     =  0d0  ! dummy
            g0      =  0d0  ! dummy
            muCR3BP =  par(i) ; i = i + 1;
            muSun   =  par(i) ; i = i + 1;
            rhoSun  =  par(i) ; i = i + 1;
            thetaS0 =  par(i) ; i = i + 1;
            omegaS  =  par(i) ; i = i + 1;
            m0      =  par(i) ; i = i + 1;
            lambda  =  0d0  ! dummy
            tf_par  =  0d0  ! dummy
        elseif (choixpb.eq.1) then ! minimal energy
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
            Isp     =  0d0  ! dummy
            g0      =  0d0  ! dummy
            muCR3BP =  par(i) ; i = i + 1;
            muSun   =  par(i) ; i = i + 1;
            rhoSun  =  par(i) ; i = i + 1;
            thetaS0 =  par(i) ; i = i + 1;
            omegaS  =  par(i) ; i = i + 1;
            m0      =  par(i) ; i = i + 1;
            lambda  =  0d0  ! dummy
            tf_par  =  par(i) ; i = i + 1;
        end if

    end Subroutine splitPar

!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
    Subroutine getCoefficients(npar, par,   nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                            q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                            Tmax, Isp, g0, muCR3BP, muSun, rhoSun, &
                                            thetaS0, omegaS, m0, lambda, choixpb, tf_par, pzero)
        implicit none
        integer,            intent(in)  :: npar
        double precision,   intent(in)  :: par(npar)
        double precision,   intent(out) :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
        double precision,   intent(out) :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
        double precision,   intent(out) :: Tmax, Isp, g0, muCR3BP, muSun, rhoSun
        double precision,   intent(out) :: thetaS0, omegaS, m0, lambda, tf_par, pzero
        integer, intent(out)            :: nparmin, choixpb


        call splitPar(npar, par,    nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0,     &
                                    q1_f, q2_f, q3_f, v1_f, v2_f, v3_f,     &
                                    Tmax, Isp, g0, muCR3BP, muSun, rhoSun,  &
                                    thetaS0, omegaS, m0, lambda, choixpb, tf_par)

        pzero = -1d0

    End Subroutine getCoefficients

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
        double precision, dimension(n*4),   intent(out) :: Fi                               ;

        !Local declarations
        integer          :: nparmin
        integer          :: i, choixpb
        double precision :: f0(n), f1(n), f2(n), f3(n), f4(n)
        double precision :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
        double precision :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
        double precision :: Tmax, Isp, g0, mu, muSun, rhoSun, thetaS0, omegaS, m0, lambda, tf_par
        double precision :: r1, r2, thetaS, rS, q1, q2, q3, v1, v2, v3, pzero

        call getCoefficients(npar, par, nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                        q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                        Tmax, Isp, g0, mu, muSun, rhoSun,   &
                                        thetaS0, omegaS, m0, lambda, choixpb, tf_par, pzero)

        q1      = z(1)                                                                      ;
        q2      = z(2)                                                                      ;
        q3      = z(3)                                                                      ;
        v1      = z(4)                                                                      ;
        v2      = z(5)                                                                      ;
        v3      = z(6)                                                                      ;


        r1      = sqrt((q1+mu)**2   + q2**2 + q3**2);
        r2      = sqrt((q1-1+mu)**2 + q2**2 + q3**2);

        if(choixpb.eq.0) then
            thetaS  = thetaS0 + omegaS*t;
        elseif(choixpb.eq.1) then
            thetaS  = thetaS0 + omegaS*t*tf_par;
        endif

        rS      = sqrt((q1-rhoSun*cos(thetaS))**2 + (q2-rhoSun*sin(thetaS))**2 + q3**2);

        if ((choixpb.eq.0).or.(choixpb.eq.1)) then ! minimal time or energy : x = (q1, q2, q3, v1, v2, v3)

            f0      = (/ v1, v2, v3,                                                                &
                         2d0*v2 + q1 - (1d0-mu)*(q1+mu)/r1**3   - mu*(q1-1d0+mu)/r2**3  -           &
                        (q1-rhoSun*cos(thetaS))*muSun/rS**3     - muSun*cos(thetaS)/rhoSun**2,      &
                        -2d0*v1 + q2 - (1d0-mu)*q2/r1**3        - mu*q2/r2**3           -           &
                        (q2-rhoSun*sin(thetaS))*muSun/rS**3     - muSun*sin(thetaS)/rhoSun**2,      &
                                     - (1d0-mu)*q3/r1**3        - mu*q3/r2**3   - q3*muSun/rS**3   /)

            f1      = (/ 0d0, 0d0, 0d0, Tmax/m0, 0d0, 0d0 /)
            f2      = (/ 0d0, 0d0, 0d0, 0d0, Tmax/m0, 0d0 /)
            f3      = (/ 0d0, 0d0, 0d0, 0d0, 0d0, Tmax/m0 /)

        end if

        i           = 1                                                                     ;
        Fi(i:i-1+n) = f0;   i = i + n;
        Fi(i:i-1+n) = f1;   i = i + n;
        Fi(i:i-1+n) = f2;   i = i + n;
        Fi(i:i-1+n) = f3;   i = i + n;

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
        double precision, dimension(4),     intent(out) :: Hi

        !Local declarations
        double precision    :: F(n*4), fi(n), p(n)
        integer             :: i, j, m

        !Nombre de champs de vecteurs
        m       = 4

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
        double precision    :: Hi(4), H0, H1, H2, H3, nu, phi, pzero, psi
        double precision    :: q1_0, q2_0, q3_0, v1_0, v2_0, v3_0
        double precision    :: q1_f, q2_f, q3_f, v1_f, v2_f, v3_f
        double precision    :: Tmax, Isp, g0, muCR3BP, muSun, rhoSun, thetaS0, omegaS, m0, lambda, tf_par
        double precision    :: uiarc

        call getCoefficients(npar, par, nparmin, q1_0, q2_0, q3_0, v1_0, v2_0, v3_0, &
                                        q1_f, q2_f, q3_f, v1_f, v2_f, v3_f, &
                                        Tmax, Isp, g0, muCR3BP, muSun, rhoSun, &
                                        thetaS0, omegaS, m0, lambda, choixpb, tf_par, pzero)

        call relevement(t,n,z,iarc,npar,par,Hi)
        H0 = Hi(1)
        H1 = Hi(2)
        H2 = Hi(3)
        H3 = Hi(4)

        nu = sqrt(H1**2+H2**2+H3**2)

        u  = 0d0
        if (choixpb.eq.0) then ! minimal time
            u(1) = H1/nu
            u(2) = H2/nu
            u(3) = H3/nu
        elseif (choixpb.eq.1) then ! minimal energy
            u(1) = -H1/(2d0*pzero)
            u(2) = -H2/(2d0*pzero)
            u(3) = -H3/(2d0*pzero)
        end if

    end subroutine control
