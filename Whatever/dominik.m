
% M = matrix of data
% theta = -90 - 90
% phi = 0 - 330
clear x y z
%  theta = -90:5:90;      phi = 0:30:360;
  theta = -110:5:110;      phi = 0:30:360;
theta = theta.*pi/180;  phi = phi.*pi/180;

x = M .* sin(theta) .* sin(phi');
y = -M .* sin(theta) .* cos(phi');

s=surf(x,y,M);

hold on
set(gca,'xcolor','none','ycolor','none','xgrid','off','ygrid','off')
set(gcf,'Position',[10,10,1000,1000])
limits=floor(max(abs([min(min(x))-5, max(max(x))+5, min(min(y))-5, max(max(y))+5])));
%limits=10*10e-5;
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

s.LineStyle = '--';
s.Marker = '.';
s.MarkerSize = 10;
s.MarkerFaceColor = 'k';
zlabel('Světelný tok [lm]');
title('Komb2')
colormap(jet);
%{
close all
name="White";

theta = -90:5:90; theta = theta.*pi/180;
f1=figure;
polarplot(theta, M(1,:), theta, M(4,:), theta, M(7,:), theta, M(10,:))
set(gca,'ThetaLim',[-90,90],'ThetaDir','clockwise','ThetaZeroLocation','top')
ax=gca;ax.RAxis.Label.String='Jas [cd/m^2]';
set(gcf,'Position',[10,10,1000,1000])
title(name);

f2=figure;
polarplot(theta, M(1,:), theta, M(4,:), theta, M(7,:), theta, M(10,:))
set(gcf,'Position',[10,10,1000,1000])
title(name);


theta = -110:5:110;theta = theta.*pi/180;
f1=figure;
polarplot(theta, M)
set(gcf,'Position',[10,10,1000,1000])
set(gca,'ThetaLim',[-90,90],'ThetaDir','clockwise','ThetaZeroLocation','top')
ax=gca;ax.RAxis.Label.String='Světelný tok [lm]';
title(name);

f2=figure;
polarplot(theta, M)
set(gcf,'Position',[10,10,1000,1000])
title(name);

f3=figure;
polarplot(theta, M)
set(gcf,'Position',[10,10,1000,1000])
set(gca,'ThetaLim',[-110,110],'ThetaDir','clockwise','ThetaZeroLocation','top')
ax=gca;ax.RAxis.Label.String='Světelný tok [lm]';
title(name);
%}
for i=1:100
clear t1 t2
tic;
I=intensity./sum(intensity);
t1=toc;
clear I;
tic;
I=normalize(intensity);
t2=toc;
clear I
diff(i)=t1-t2;
end
