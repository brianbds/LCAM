%This script is used for computing luminance valu over 3 stripes where only
%the 2nd stripe is selected in a box and the TOP/BOTTOM stripe is boxed
%automatically
%   /´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´\                 /´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´´\                                                                                                                        
%  |                                                        |                |                                                        |                                                                 
%  |             ||||||||||||||||||||             |                |      1      ||||||||||||||||||||        3   |                                                                                             
%  |                                                        |    ==>    |        XˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇX  |                                                                        
%  |              ||||||||||||||||||||            |                |       |       ||||||||||||||||||||      |   |                                                                                             
%  |                                                        |                |       X________________________X  |                                                                
%  |             ||||||||||||||||||||||          |                |      2     ||||||||||||||||||||||     4   |
%  \_______________________________/                  \_______________________________/                                                                                                                      

clear
samples = 50; % Number of samples
%If files put 1 if direcotries put 2
fOd=2 ;
if fOd==1
    [files, path, Acoor]=get_files;
else
    [files, path, Acoor]=get_directories;
end
long=length(path);
lum=zeros([samples,long*3]);
for k=1:long
    s=size(files{1,k});
    if s<samples
        files{1,k}(end+1:samples)=files{1,k}(end);
    end
    % Sorting coordinate in order to have corners 1-4 exatcly in positions 1-4
    coor=sortrows(Acoor(:,:,k));
    coor([1,2],:)=sortrows(coor([1,2],:),2);
    coor([3,4],:)=sortrows(coor([3,4],:),2);
    clear l
    t=max(coor(:,1)-min(coor(:,1)))<max(coor(:,2)-min(coor(:,2)));
    [coor(:,:,1),coor(:,:,2),coor(:,:,3)]=deal(coor);
    if t
        %Extending coordinates UP and DOWN in order to read stripes
        d=floor((coor(3,1,2)-coor(1,1,2)+coor(4,1,2)-coor(2,1,2))/2);
        
        coor(1,:,1)=[floor((coor(1,1,1)+coor(2,1,1))/2-d), floor((coor(1,2,1)+coor(3,2,1))/2)];
        coor(2,:,1)=[floor((coor(3,1,1)+coor(4,1,1))/2-d), floor((coor(2,2,1)+coor(4,2,1))/2)];
        
        coor(1,:,3)=[floor((coor(1,1,3)+coor(2,1,3))/2+d), floor((coor(1,2,3)+coor(3,2,3))/2)];
        coor(2,:,3)=[floor((coor(3,1,3)+coor(4,1,3))/2+d), floor((coor(2,2,3)+coor(4,2,3))/2)];
        
        coor(1,:,2)=[floor((coor(1,1,2)+coor(2,1,2))/2), floor((coor(1,2,2)+coor(3,2,2))/2)];
        coor(2,:,2)=[floor((coor(3,1,2)+coor(4,1,2))/2), floor((coor(2,2,2)+coor(4,2,2))/2)];
        
        coor(3:4,:,:)=[];
    else
        error('Vertical picture, call Brian');
    end
   
    for i=1:samples
        pic=double(imread(char(fullfile(path(k),files{k}(i)))))./255;
        [r,c,~]=size(pic);
        coor(:,:,1)=check_size(coor(:,:,1),r,c);  coor(:,:,2)=check_size(coor(:,:,2),r,c);  coor(:,:,3)=check_size(coor(:,:,3),r,c);
        if r>c
            pic=rot90(pic);
        end
        for o=1:3
            %Core processing loop
            picture=pic(coor(1,1,o):coor(2,1,o),coor(1,2,o):coor(2,2,o),:);
            if i==1;imshow(picture.*255);pause(2);close all;end
            lum(i,k*3+o-3)=RGB2lum(reshape(picture(:),[],3));
        end
    end
end
path=path(:);
clear N i filename files luminance picture RGBMultiplier Acoor c coor d l k i r t pa fi long I o pic s fOd
plot(lum)
