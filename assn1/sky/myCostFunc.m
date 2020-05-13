function [ a , c , s ] = myCostFunc( img )

grey_cloud = [1 1 1];
grey_sky = [0 100 200];

for row = 0 :255
    for col = 0:255
        cloud = c(row,col).*transpose(grey_cloud) ; 
        sky = s(row, col).*transpose(grey_sky) ; 
        p = img(row,col,:);
        R = (s(row,col)-1).^2; 
        D = ( a.*cloud +(1-a).*sky  + (0.5).*p ).^2 ; 
        J = J + D + R ; 
    end
end 

a = 1 ; 
c = 255 ;
s = 255 ; 
     
end

