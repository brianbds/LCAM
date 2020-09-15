[file,path]=uigetfile('*.lvm');
G=fileread(fullfile(path,file));
G=G(:);
lvm=strrep(string(ones([10000,39])),'1','');k=1;i=1;l=1;tb=char(9);en=char(13);
while i<length(G)
    if i==(16*14+5)
        y=1;
    end
    
    if G(i)==tb
        l=l+1;
    elseif G(i)==en
        k=k+1;
        i=i+1;
        l=1;
    else
        lvm(k,l)=lvm(k,l)+G(i);
    end
    
    
    
    i=i+1;
end
lvm=str2double(strrep(lvm,',','.'));

lvm=[380:10:760;lvm];
lvm(isnan(lvm(:,1)),:)=[];
lvm=[[0;(0:2:(length(lvm)-2)*2)'],lvm];