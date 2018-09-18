%
% Script pour tracer les orbites initiale et finale
% q0 et v0 = position et vitesse en t_0
% rf = rayon de l'orbite geostationnaire
% mu = constante gravitationnelle
%
function orbite0f(q0, mu, rf)

q0  = q0(:)';

% La Terre
markerXLW    = 2.0;
markerXSize  = 7.5;
markerXColor = [0.1 0.1 0.8]; % bleu
plot(0.0, 0.0,'--ro','LineWidth',markerXLW,'MarkerEdgeColor',markerXColor,'MarkerFaceColor',markerXColor,'MarkerSize',markerXSize);
hold on;

% orbite initiale
r0  = norm(q0(1:2));
V0  = norm(q0(3:4));
a   = 1/(2/r0-V0*V0/mu);
t1  = r0*V0*V0/mu - 1;    % formule page 43 Zarrouati
t2  = (q0(1:2)*q0(3:4)')/sqrt(a*mu);
e   = norm([t1 t2]);
p   = a*(1-e^2);

npas= 100;
pas = 2*pi/npas;
for i=1:npas,
    theta   = (i-1)*pas;
    r       = p/(1+e*cos(theta));
    x1(i)   = r*cos(theta) ;
    x2(i)   = r*sin(theta);
end;
x1(npas+1)  = x1(1);
x2(npas+1)  = x2(2);

plot(x1,x2); hold on;

% orbite finale circulaire
%
npas    = 100;
pas     = 2*pi/npas;
for i=1:npas,
    theta   = (i-1)*pas;
    x1(i)   = rf*cos(theta) ;
    x2(i)   = rf*sin(theta);
end;
x1(npas+1)  = x1(1);
x2(npas+1)  = x2(2);

plot(x1,x2);

