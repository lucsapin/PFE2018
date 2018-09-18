!!
!!  \author Olivier Cots (INP-ENSEEIHT-IRIT)
!!  \date   2018
!!
!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
    Subroutine splitPar(npar, par, x01, x02, x03, x04, mu, rf, gm)
        implicit none
        integer,            intent(in)  :: npar
        double precision,   intent(in)  :: par(npar)
        double precision,   intent(out) :: x01, x02, x03, x04, mu, rf, gm

        !local variables
        integer :: i

        i   =  2;
        x01 =  par(i) ; i = i + 1;
        x02 =  par(i) ; i = i + 1;
        x03 =  par(i) ; i = i + 1;
        x04 =  par(i) ; i = i + 1;
        mu  =  par(i) ; i = i + 1;
        rf  =  par(i) ; i = i + 1;
        gm  =  par(i) ; i = i + 1;

    end Subroutine splitPar

!! --------------------------------------------------------------------------------------------
!! --------------------------------------------------------------------------------------------
    Subroutine getCoefficients(npar, par, x01, x02, x03, x04, mu, rf, gm)
        implicit none
        integer,            intent(in)  :: npar
        double precision,   intent(in)  :: par(npar)
        double precision,   intent(out) :: x01, x02, x03, x04, mu, rf, gm

        call splitPar(npar, par, x01, x02, x03, x04, mu, rf, gm)

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
        double precision, dimension(n*3),   intent(out) :: Fi                               ;

        !Local declarations
        integer             :: nparmin
        integer             :: i                                                            ;
        double precision    :: f0(n), f1(n), f2(n)                                          ;
        double precision    :: x01, x02, x03, x04, mu, rf, gm, r                            ;
        double precision    :: x1, x2, x3, x4                                               ;

        nparmin = nint(par(1)) !nparmin compte le premier element

        IF (n.NE.4) THEN
            call printandstop('Error in hfun: wrong state dimension.')
        END IF
        IF (npar.lt.nparmin) THEN
            call printandstop('Error in hfun: wrong par dimension.')
        END IF

        call getCoefficients(npar, par, x01, x02, x03, x04, mu, rf, gm)

        x1      = z(1)                                                                      ;
        x2      = z(2)                                                                      ;
        x3      = z(3)                                                                      ;
        x4      = z(4)                                                                      ;

        r       = sqrt(x1**2+x2**2)

        f0      = (/ x3, x4, -mu*x1/r**3, -mu*x2/r**3/)                                     ;
        f1      = (/ 0d0, 0d0, 1d0, 0d0/)                                                   ;
        f2      = (/ 0d0, 0d0, 0d0, 1d0/)                                                   ;

        i           = 1                                                                     ;
        Fi(i:i-1+n) = f0;   i = i + n;
        Fi(i:i-1+n) = f1;   i = i + n;
        Fi(i:i-1+n) = f2;   i = i + n;

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
        double precision, dimension(3),     intent(out) :: Hi

        !Local declarations
        integer             :: nparmin
        double precision    :: F(n*3), fi(n), p(n)
        integer             :: i, j, m

        nparmin = nint(par(1)) !nparmin compte le premier element

        IF (n.NE.4) THEN
            call printandstop('Error in hfun: wrong state dimension.')
        END IF
        IF (npar.lt.nparmin) THEN
            call printandstop('Error in hfun: wrong par dimension.')
        END IF

        !Nombre de champs de vecteurs
        m       = 3

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
        double precision, dimension(2),     intent(out) :: u

        !Local declarations
        integer             :: nparmin
        double precision    :: Hi(3), H0, H1, H2
        double precision    :: x01, x02, x03, x04, mu, rf, gm

        nparmin = nint(par(1)) !nparmin compte le premier element

        IF (n.NE.4) THEN
            call printandstop('Error in hfun: wrong state dimension.')
        END IF
        IF (npar.lt.nparmin) THEN
            call printandstop('Error in hfun: wrong par dimension.')
        END IF

        call getCoefficients(npar, par, x01, x02, x03, x04, mu, rf, gm)
        call relevement(t,n,z,iarc,npar,par,Hi)
        H1 = Hi(2)
        H2 = Hi(3)

        u(1) = gm*H1/sqrt(H1**2+H2**2)
        u(2) = gm*H2/sqrt(H1**2+H2**2)

    end subroutine control
