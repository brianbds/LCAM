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
        
        function  [files, path, together_coor]= get_directories(num)
            filedatas=struct2table(dir(fullfile(uigetdir('C:\'),'**\*.jpg')));
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
                    together_coor(:,:,i,j)=visLib.get_coordinates(path(i),files{1,i}(1,1));
                    j=j+1;
                end
                i=i+1; j=1;
            end
        end
        
        function [files, path, together_coor]=get_files(num)
            i=1; j=1;
            while 1==1
                [fi,pa]= uigetfile('MultiSelect','on','*.jpg');
                if str2double(string(pa))==0; break; end
                while j<=num
                    together_coor(:,:,i)=visLib.get_coordinates(pa,fi{1,i});
                    j=j+1;
                end
                files{i}=fi;path(i)=string(pa);clear fi pa; i=i+1; j=1;
            end
            clear I
        end
        
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
    end
end