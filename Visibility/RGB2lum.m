function [luminance]=RGB2lum(photo)
photo(photo<=0.04045)=photo(photo<=0.04045)./12.92;
photo(photo>0.04045)=(((photo(photo>0.04045)+0.055)./1.055)).^2.4;
photo=photo(:,1).*0.2126+photo(:,2).*0.7152+photo(:,3).*0.0722;
photo(photo<0.001)=0;
luminance=mean2(nonzeros(photo));
end