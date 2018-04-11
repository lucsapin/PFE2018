function q = CR3BP2EMB(qCR3BP, t, xG_EMB)
% Convert the state qCR3BP expressed in CR3BP rotating frame into q
% expressed on EMB interial frame (LD,LD/d)

    UC          = get_Univers_Constants();

    if (nargin < 3)
        xG_EMB = UC.xG_EMB0;
        xG_EMB(1) = xG_EMB(1)*UC.AU/UC.LD; % En LD
    end;

    [~,qM,~,~] = EMBstates(t, xG_EMB); % En LD

    % Convert qCR3BP to EMB inertial and (LD,LD/d)
    cT  = (UC.jour/UC.time_syst); % time conversion
    Ox  = qM(1:3)/norm(qM(1:3),2);
    Oz  = cross(qM(1:3),qM(4:6)); Oz = Oz/norm(Oz,2);
    Oy  = cross(Oz,Ox); Oy = Oy/norm(Oy,2); % normalisation not really needed
    M   = [Ox'; Oy'; Oz']; % change of coordinates matrix
    R   = M'*qCR3BP(1:3);
    V   = cT*M'*(qCR3BP(4:6)+cross([0;0;1],qCR3BP(1:3)));
    q   = [R;V];

end

