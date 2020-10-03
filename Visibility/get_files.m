function [files, path, together_coor]=get_files
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
    together_coor(:,:,i)=floor(coor);
    files{i}=fi;path(i)=string(pa);clear fi pa; i=i+1;
end
clear I
end