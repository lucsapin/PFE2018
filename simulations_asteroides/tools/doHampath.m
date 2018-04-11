function [ parout, xout, sout, viout, dets, normS, ps, flag ] = doHampath(parspan,x0,options,itermax)

if(nargin<4)
    itermax = 0;
end;

[ parout, xout, sout, viout, dets, normS, ps, flag] = hampath(parspan,x0,options);

turningPoint = length(find(viout(end,1:end-1).*viout(end,2:end) < 0))

if(itermax>0 & turningPoint == 0)
    if(flag==-2 | flag==-5 | flag==-6)
        i=2;
        fini=0;
        %imax = ceil(2*itermax/3);
        imax = itermax;
        fprintf('methode PC avec %d corrections\n',imax);
        while((flag==-2 | flag==-5 | flag==-6) & i<=imax & fini==0 & turningPoint == 0)
                options = hampathset(options,'TolOdeAbs'            ,hampathget(options,'TolOdeAbs'         )/10);
                options = hampathset(options,'TolOdeRel'            ,hampathget(options,'TolOdeRel'         )/10);
                options = hampathset(options,'TolOdeHamAbs'         ,hampathget(options,'TolOdeHamAbs'      )/10);
                options = hampathset(options,'TolOdeHamRel'         ,hampathget(options,'TolOdeHamRel'      )/10);
                options = hampathset(options,'MaxStepsOdeHam'       ,max(hampathget(options,'MaxStepsOdeHam')-100,10));
                options = hampathset(options,'MaxSfunNorm'          ,hampathget(options,'MaxSfunNorm'       )/5);
                options = hampathset(options,'MaxIterCorrection'    ,hampathget(options,'MaxIterCorrection' )+1);

                flagSsolve=0;
                s = 1;
                ii = length(sout);
                while(flagSsolve~=1 & ii>0 & norm(s)>1e-7)
                        x0  = xout(:,ii);
                        par = parout(:,ii);
                        [xsol,s,nfev,njev,flagSsolve] = ssolve(x0,options,par); 
                        ii = ii - 1;
                        flagSsolve
                end;
                ii
                if(ii~=0)
                        x0  = xsol;
                        parspan2 = [par parspan(:,end)];
                        [ parout2, xout2, sout2, viout2, dets2, normS2, ps2, flag ] = hampath(parspan2,x0,options);
                        turningPoint = length(find(viout2(end,1:end-1).*viout2(end,2:end) < 0))

                        if(length(sout2)<5)
                                fini=1;
                        end;

                        if(ii>=1)
                            parout  = [parout(:,1:ii-1)         parout2             ];
                            xout    = [xout(:,1:ii-1)           xout2               ];
                            sout    = [sout(1:ii-1)             sout(ii-1)+sout2    ];
                            viout   = [viout(:,1:ii-1)          viout2              ];
                            dets    = [dets(1:ii-1)             dets2               ];
                            normS   = [normS(1:ii-1)            normS2              ];
                            ps      = [ps(1:ii-1)               ps2                 ];
                        end;

                        i = i + 1;
                else
                        fini = 1;
                end;
        end;
    end;
end;

return
