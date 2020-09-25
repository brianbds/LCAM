%This script is used for computing luminance valu over one big patch of a
%cloth by selecting all files, writing number of samples and if necessary
%changing the multiplier values
%   /´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´\                 /´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´\                                                                                                                        
%  |                                                        |                |     1 XˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇX 4 |                                                                 
%  |             ||||||||||||||||||||             |                |       |      ||||||||||||||||||||      |    |                                                                                             
%  |              ||||||||||||||||||||            |    ==>    |       |       ||||||||||||||||||||      |    |                                                                        
%  |              ||||||||||||||||||||            |                |       |      ||||||||||||||||||||      |    |                                                                                             
%  |              |||||||||||||||||||||          |                |       |        |||||||||||||||||||||   |    |                                                                
%  |                                                        |                |    2 X_______________________X  3|
%  \_______________________________/                  \_______________________________/                                                                                                                      

clear 

samples = 50; % Number of samples
RGBMultiplier=[0.2126,0.7152,0.0722]; % RGB multiplying values

i=1;
while 1==1
    [fi,pa]= uigetfile('MultiSelect','on','*.jpg');
    if str2double(string(pa))==0; break; end
    
    I=1./double(imread(fullfile(pa,fi{1,i})));
    [r,c,~]=size(I);
    if r>c
        figure,imshow(rot90(I),[])
    else
        figure,imshow(I,[])
    end
    % Selecting corners on a picture
    [coor(1,2),coor(1,1)] = ginput(1);
    hold on;
    plot(coor(1,2),coor(1,1),'r+', 'MarkerSize', 25);
    [coor(2,2),coor(2,1)] = ginput(1);
    plot(coor(2,2),coor(2,1),'b+', 'MarkerSize', 25);
    [coor(3,2),coor(3,1)] = ginput(1);
    plot(coor(3,2),coor(3,1),'r+', 'MarkerSize', 25);
    [coor(4,2),coor(4,1)] = ginput(1);
    plot(coor(4,2),coor(4,1),'b+', 'MarkerSize', 25);
    close all
    Acoor(:,:,i)=floor(coor);
    files{i}=fi;path(i)=string(pa);clear fi pa; i=i+1;
end
clear I
lum=zeros([samples,1]);
g=length(path);
for k=1:g
    s=size(files{1,k});
    if s(2)<samples
        files{1,k}(end+1:samples)=files{1,k}(end);
    end
    % Sorting coordinate in order to have corners 1-4 exatcly in positions 1-4
    coor=sortrows(Acoor(:,:,g));
    coor([1,2],:)=sortrows(coor([1,2],:),2);
    coor([3,4],:)=sortrows(coor([3,4],:),2);
    coor=[floor(mean(coor([1,2],1))) ,floor(mean(coor([1,3],2))) ;floor(mean(coor([3,4],1))) ,floor(mean(coor([2,4],2)))];
    for i=1:samples
        %Core processing loop
        picture=double(imread(char(fullfile(path(k),files{k}(i)))))./255;
        [r,c,~]=size(picture);
        if r>c;picture=rot90(picture);end
        picture=picture(coor(1,1):coor(2,1),coor(1,2):coor(2,2),:);
        if i==1;imshow(picture.*255);pause(2);close all;end
        picture(picture<=0.04045)=picture(picture<=0.04045)./12.92;
        picture(picture>0.04045)=(((picture(picture>0.04045)+0.055)./1.055)).^2.4;
        picture=picture(:,:,1).*RGBMultiplier(1)+picture(:,:,2).*RGBMultiplier(2)+picture(:,:,3).*RGBMultiplier(3);
        picture(picture<0.001)=0;
        lum(i,k)=sum(sum(picture));
    end
end
path=path(:);
plot(lum)
clear N i filename files luminance picture RGBMultiplier Acoor c coor fi g k pa r s
