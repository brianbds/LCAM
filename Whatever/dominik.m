
% M = matrix of data
% theta = -90 - 90
% phi = 0 - 330
clear x y z
  theta = -90:5:90;      phi = 0:30:330;
%  theta = -110:5:110;      phi = 0:90:270;
theta = theta.*pi/180;  phi = phi.*pi/180;

x = M .* sin(theta) .* sin(phi');
y = -M .* sin(theta) .* cos(phi');

surf(x,y,M);
hold on
set(gca,'xcolor','none','ycolor','none','xgrid','off','ygrid','off')
limits=floor(max(abs([min(min(x))-5, max(max(x))+5, min(min(y))-5, max(max(y))+5])));
xlim([-limits, limits]);
ylim([-limits, limits]);

L=150;
for i=1:7
   g1=cos((i-1)*pi/6); g2=sin((i-1)*pi/6);
   plot(L*[g1,-g1],L*[g2,-g2],'r')
end
text(limits.*[ 0,    cos(pi*5/3), 1,            1,  1,         cos(pi/3), 0,   cos(pi*2/3), -1,          -1,   -1,            cos(pi*8/3)],...
    limits.* [-1,   -1,           sin(pi*11/6), 0,  sin(pi/6), 1,         1,   1,            sin(pi*5/6), 0,    sin(pi*7/6), -1          ],...
            {'0','30',      '60',      '90','120',        '150',       '180','210',        '240',       '270','300',       '330'})
hold off



