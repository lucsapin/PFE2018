function [ti, seq, exitflag] = detectStructure(tout, nu)

% ok if exitflag = 1

ti          = [];
seq         = [];
exitflag    = -1;

LW               = 1.5;
axisColor        = 'k--';

fini = 0;
while(fini==0)
    fini = 1;
    textt = ['Click on the figure to give the structure (press enter when it is done): all times must be indicated.'];
    disp(textt);

    h = figure('Units', 'normalized', 'Position', [0 0 1 1],'Visible','on'); title(textt);
    hold on; plot(tout,nu,'m','LineWidth',LW); ax = axis; ymin = ax(3); ymax = ax(4); axis([tout(1)-0.1 tout(end)+0.1 ymin ymax]);
    daxes(tout(1),0,axisColor);
    daxes(tout(end),0,axisColor);

    finiGINPUT = 0;
    xx = [];
    yy = [];
    while(finiGINPUT==0)
        finiGINPUT = 1;
        [x,y,b] = ginput(1);
        if(~isempty(x) & b==1)
            plot(x,y,'--ro','LineWidth',1.5,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',5.0);
            plot([x x],[ymin ymax],'r--','LineWidth',2.0);
            xx(end+1)   = x;
            yy(end+1)   = y;
            finiGINPUT  = 0;
        elseif(~isempty(x) & b~=1)
            finiGINPUT  = 0;
        end;
    end;
    x = xx;
    y = yy;

    m  = length(x)-1;
    ti = [x(:)'];

    fprintf('Structure : %g arcs.\n',m);
    fprintf('Structure : '); ti
    struc = input('Donner la structure ([1 0 1 0] pour Bang-Zero-Bang-Zero) :   ');
    fprintf('Structure - signes :'); struc
    seq = struc;

    finiQuestion = 0;
    while(finiQuestion==0)
        finiQuestion = 1;
        flag = input('Valider structure ? (0 : non et quitter, 1 : oui et sauvegarder, 2 : non et recommencer) ');
        switch lower(flag)
            case(1)
                disp('Structure detected and saved');
                exitflag = 1;
            case(0)
                disp('Structure not detected and not saved because of stopping!');
            case(2)
                disp('Redo detection!');
                fini = 0;
            otherwise
                disp('Wrong choice!');
                finiQuestion = 0;
        end;
    end;
    %close(h);
end;

ti(1) = tout(1);
ti(end) = tout(end);

return

