

for i=1:12
    x(i,:)=M(i,:).*cos(theta)*sin(phi(i));
    y(i,:)=M(i,:).*cos(theta)*cos(phi(i));
    z(i,:)=M(i,:).*sin(theta);
end
surf(x,y,z);
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
text(limits.*[1,  1,         cos(pi/3), 0,   cos(pi*2/3), -1,          -1,   -1,            cos(pi*8/3), 0,    cos(pi*5/3), 1           ],...
    limits.* [0,  sin(pi/6), 1,         1,   1,            sin(pi*5/6), 0,    sin(pi*7/6), -1,          -1,   -1,           sin(pi*11/6)],...
            {'0','30',      '60',      '90','120',        '150',       '180','210',        '240',       '270','300',       '330'})


text([limits, limits],[0, sin(pi/6)],{'0','30'})

[x,y,z]=sph2cart(phi,theta,M(1,:));
