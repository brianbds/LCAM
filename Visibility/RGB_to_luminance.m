%This script is used for computing luminance valu over one big patch of a
%cloth by selecting all files, writing number of samples and if necessary
%changing the multiplier values
%   /´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´\                 /´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´\                                                                                                                        
%  |                                              |                |     1 XˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇX 4 |                                                                 
%  |             ||||||||||||||||||||             |                |       |      ||||||||||||||||||||      |    |                                                                                             
%  |              ||||||||||||||||||||            |    ==>         |       |       ||||||||||||||||||||     |    |                                                                        
%  |              ||||||||||||||||||||            |                |       |      ||||||||||||||||||||      |    |                                                                                             
%  |              |||||||||||||||||||||           |                |       |        |||||||||||||||||||||   |    |                                                                
%  |                                              |                |     2 X________________________________X 3  |
%  \______________________________________________/                 \____________________________________________/                                                                                                                      

clear 
num = 1; % Number of patches on one sample
fOd= 2 ; % If files put 1 if direcotries put 2
samples = 50; % Number of samples
if 1==1
if fOd==1
    [files, path, Acoor]=visLib.get_files(num);
else
    [files, path, Acoor]=visLib.get_directories(num);
end
long=length(path);
lum=zeros([samples,long*num]);
for k=1:long
    s=size(files{1,k});
    if s(2)<samples
        files{1,k}(end+1:samples)=files{1,k}(end);
    end
    % Creating mask for computations and selecting pixels for mean
    picture=double(imread(char(fullfile(path(k),files{k}(1)))))./255;
    [r,c,~]=size(picture);
     if r>c;[c,r,~]=size(picture);picture=rot90(picture);end
     mask=false([r c num]);
     for o=1:num
         mask(:,:,o) = poly2mask(Acoor(:,2,k,o),Acoor(:,1,k,o),r,c);
         [lum(1,k*num+o-num),pixels{o}]=visLib.RGB2lum(reshape(picture([mask(:,:,o),mask(:,:,o),mask(:,:,o)]),[],3));
         % Displaying picture
         I=mask(:,:,o)./picture;  I(isnan(I))=255;  I(I==0)=255; I(isinf(I))=255;
         imshow(I./255);pause(2);close all; clear I
     end
    % Core processing loop
    for i=2:samples
        picture=double(imread(char(fullfile(path(k),files{k}(i)))))./255;
        [r,c,~]=size(picture);
        if r>c;picture=rot90(picture);end
        for o=1:num
            [lum(i,k*num+o-num)]=visLib.RGB2lum(reshape(picture([mask(:,:,o),mask(:,:,o),mask(:,:,o)]),[],3),pixels{o});
        end
    end
end
path=path(:); number_of_patches = num;
plot(lum)
clear N i filename files luminance picture RGBMultiplier Acoor c coor fi long k pa r s mask fOd j o num pixels
end