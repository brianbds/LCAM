clear lum
i=1;
while 1==1
    [fi,pa]= uigetfile('MultiSelect','on','*.jpg');
    if str2double(string(pa))==0; break; end
    files{i}=fi;path(i)=string(pa);clear fi pa; i=i+1;
end
if ischar(files);N=1;else;N=length(files);end
RGBMultiplier=[0.2126,0.7152,0.0722];
luminance=zeros([N,1]);
lum=zeros([N,1]);
for i=1:N
   filename=string(fullfile(path,files(i)));
   picture=double(imread(filename));
   picture=picture(:,:,1).*RGBMultiplier(1)+picture(:,:,2).*RGBMultiplier(2)+picture(:,:,3).*RGBMultiplier(3);
   luminance(i,1)=sum(sum(picture));
   picture(picture<0.01)=0;
   lum(i,1)=sum(sum(picture));
end
plot(lum)
clear N i filename files luminance picture RGBMultiplier
