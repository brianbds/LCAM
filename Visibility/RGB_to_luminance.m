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
fOd= 1 ;
samples = 50; % Number of samples
if fOd==1
    [files, path, Acoor]=visLib.get_files;
else
    [files, path, Acoor]=visLib.get_directories;
end
lum=zeros([samples,1]);
long=length(path);
for k=1:long
    s=size(files{1,k});
    if s(2)<samples
        files{1,k}(end+1:samples)=files{1,k}(end);
    end
    % Creating mask for computations
    picture=imread(char(fullfile(path(k),files{k}(1))));
    [r,c,~]=size(picture);
     if r>c;[c,r,~]=size(picture);end
    mask = poly2mask(Acoor(:,2,k),Acoor(:,1,k),r,c);
    % Displaying picture
    I=mask./double(picture);  I(isnan(I))=255;  I(I==0)=255;
    imshow(I);pause(2);close all; clear I
    % Core processing loop
    for i=1:samples
        picture=double(imread(char(fullfile(path(k),files{k}(i)))))./255;imshow(mask./(picture.*255));pause(2);close all;
        [r,c,~]=size(picture);
        if r>c;picture=rot90(picture);end
        lum(i,k)=visLib.RGB2lum(reshape(picture([mask,mask,mask]),[],3));
    end
end
path=path(:);
plot(lum)
clear N i filename files luminance picture RGBMultiplier Acoor c coor fi long k pa r s mask fOd


