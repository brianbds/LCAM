clear
i=1; samples = 50;
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
RGBMultiplier=[0.2126,0.7152,0.0722];
g=length(path);
lum=zeros([samples,g*3]);
for k=1:g
    s=size(files{1,g});
    if s<samples
        files{1,g}(end+1:samples)=files{1,g}(end);
    end
    coor=sortrows(Acoor(:,:,g));
    if coor(1,2)>coor(2,2)
        l=coor(2,:);
        coor(2,:)=coor(1,:);
        coor(1,:)=l;
    end
    if coor(3,2)>coor(4,2)
        l=coor(4,:);
        coor(4,:)=coor(3,:);
        coor(3,:)=l;
    end
    clear l
    t=max(coor(:,1)-min(coor(:,1)))<max(coor(:,2)-min(coor(:,2)));
    
    [coor(:,:,1),coor(:,:,2),coor(:,:,3)]=deal(coor);
    
    
    if t
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
        pic=imread(char(fullfile(path(k),files{k}(i))));
        [r,c,~]=size(pic);
        if r>c
            pic=rot90(pic);
        end
        for o=1:3
            picture=double(pic(coor(1,1,o):coor(2,1,o),coor(1,2,o):coor(2,2,o),:))./255;
            if i==1;imshow(picture.*255);pause(2);close all;end
            picture(picture<=0.04045)=picture(picture<=0.04045)./12.92;
            picture(picture>0.04045)=(((picture(picture>0.04045)+0.055)./1.055)).^2.4;
            picture=picture(:,:,1).*RGBMultiplier(1)+picture(:,:,2).*RGBMultiplier(2)+picture(:,:,3).*RGBMultiplier(3);
            picture(picture<0.001)=0;
            lum(i,k*3+o-3)=sum(sum(picture));
        end
    end
end
path=path(:);
clear N i filename files luminance picture RGBMultiplier Acoor c coor d l k i r t pa fi g I o pic s
plot(lum)
