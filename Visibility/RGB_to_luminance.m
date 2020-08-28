[files,path]= uigetfile('MultiSelect','on','*.jpg');
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
l=luminance1./1000000;
[F,F1,F2]=fit((0:99)',l,'a*exp(-b*x)+c','Start',[-5 1 5]);
F=fit((0:99)',l,'a*exp(-b*x)+c','Start',[100 2 9])




