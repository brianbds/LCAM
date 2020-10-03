function  [files, path, together_coor]= get_directories
filedatas=struct2table(dir(fullfile(uigetdir('C:\'),'**\*.jpg')));
path=unique(string(filedatas.folder));
l=char(filedatas.name)=='.';
filedatas(l(:,1),:)=[]; clear l
u=length(path);
for i=1:u
    rw=find(string(filedatas.folder)==path(i));
    files{1,i}=filedatas.name(rw(1):rw(end));
end
together_coor=zeros([4 2 u]); i=1; clear rw filedatas
while i<=u
     I=1./double(imread(fullfile(path(i),files{1,i}(1,1))));
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
    i=i+1;
end