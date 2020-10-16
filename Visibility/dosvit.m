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
number_of_patches_per_sample = 2;
files_or_directories= 1 ; % If files put 1 if direcotries put 2
count_of_samples = 50;

[lum, paths]=images_import_and_processing(number_of_patches_per_sample, files_or_directories, count_of_samples);

%Core function for selection, import, processing and export
function [lum, paths, samples, num]=images_import_and_processing(num, fOd, samples)
    if fOd==1
        [files, path, Acoor]=get_files(num);
    else
        [files, path, Acoor]=get_directories(num);
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
            [lum(1,k*num+o-num),pixels{o}]=RGB2lum(reshape(picture([mask(:,:,o),mask(:,:,o),mask(:,:,o)]),[],3));
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
                [lum(i,k*num+o-num)]=RGB2lum(reshape(picture([mask(:,:,o),mask(:,:,o),mask(:,:,o)]),[],3),pixels{o});
            end
        end
    end
    paths=path(:);
    plot(lum)
    clear N i filename files luminance picture RGBMultiplier Acoor c coor fi long k pa r s mask fOd j o num pixels
end

% Transform RGB picture to mean luminance from selected patch
function [luminance,noise]=RGB2lum(picture,varargin)
picture(picture<=0.04045)=picture(picture<=0.04045)./12.92;
picture(picture>0.04045)=(((picture(picture>0.04045)+0.055)./1.055)).^2.4;
picture=picture(:,1).*0.2126+picture(:,2).*0.7152+picture(:,3).*0.0722;
%luminance=mean2(nonzeros(picture));
if nargin ==1
    noise=picture>0.001;
    luminance=mean(picture(noise));
else
    luminance=mean(picture(varargin{1}));
end
end

% Gets alld files from all directoris inside specified mother
% directory then they will be processed
function  [files, path, together_coor]= get_directories(num)
filedatas=struct2table(dir(fullfile(uigetdir('C:\'),char(fullfile("**","*.jpg")))));
path=unique(string(filedatas.folder));
l=char(filedatas.name)=='.';
filedatas(l(:,1),:)=[]; clear l
u=length(path);
for i=1:u
    rw=find(string(filedatas.folder)==path(i));
    files{1,i}=filedatas.name(rw(1):rw(end));
end
together_coor=zeros([4 2 u num]); i=1; j=1; clear rw filedatas
while i<=u
    while j<=num
        together_coor(:,:,i,j)=get_coordinates(path(i),files{1,i}(1,1));
        j=j+1;
    end
    i=i+1; j=1;
end
end

% Get files where user is able to select as many as he likes but
% only the amount equal to the samples number will get processed
function [files, path, together_coor]=get_files(num)
i=1; j=1;
while 1==1
    [fi,pa]= uigetfile('MultiSelect','on','*.jpg');
    if str2double(string(pa))==0; break; end
    if ischar(fi); fi={fi}; end
    while j<=num
        together_coor(:,:,i,j)=get_coordinates(pa,fi{1,i});
        j=j+1;
    end
    files{i}=fi;path(i)=string(pa);clear fi pa; i=i+1; j=1;
end
clear I
end

% Get patch coordinates
function [coordinates]=get_coordinates(path,file)
I=1./double(imread(fullfile(path,file)));
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
coordinates=floor(coor);
end