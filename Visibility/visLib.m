classdef visLib
    methods(Static)
        
        function [luminance]=RGB2lum(photo)
            photo(photo<=0.04045)=photo(photo<=0.04045)./12.92;
            photo(photo>0.04045)=(((photo(photo>0.04045)+0.055)./1.055)).^2.4;
            photo=photo(:,1).*0.2126+photo(:,2).*0.7152+photo(:,3).*0.0722;
            photo(photo<0.001)=0;
            luminance=mean2(nonzeros(photo));
        end
        
        function [coordinates]=check_size(coordinates, numRows, numCols)
            checkArray = [coordinates(1,1)<1, coordinates(1,2)<1; coordinates(2,1)>numRows, coordinates(2,2)>numCols];
            coordinates = checkArray.*[1, 1; numRows, numCols]+ (~checkArray).*coordinates;
        end
        
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
        end
        
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
        
    end
end