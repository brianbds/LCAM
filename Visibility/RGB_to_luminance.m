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
%If files put 1 if direcotries put 2
fOd= 2 ;
samples = 50; % Number of samples
RGBMultiplier=[0.2126,0.7152,0.0722]; % RGB multiplying values
if fOd==1
    [files, path, Acoor]=get_files;
else
    [files, path, Acoor]=get_directories;
end
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
        coor=check_size(coor,r,c);
        picture=picture(coor(1,1):coor(2,1),coor(1,2):coor(2,2),:);
        if i==1;imshow(picture.*255);pause(2);close all;end
        picture(picture<=0.04045)=picture(picture<=0.04045)./12.92;
        picture(picture>0.04045)=(((picture(picture>0.04045)+0.055)./1.055)).^2.4;
        picture=picture(:,:,1).*RGBMultiplier(1)+picture(:,:,2).*RGBMultiplier(2)+picture(:,:,3).*RGBMultiplier(3);
        picture(picture<0.001)=0;
        lum(i,k)=mean2(nonzeros(picture));
    end
end
path=path(:);
plot(lum)
clear N i filename files luminance picture RGBMultiplier Acoor c coor fi g k pa r s


