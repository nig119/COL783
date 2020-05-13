function [ Blur ] = Bblur( B )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    

K = 1 - B ; 
 [row , col] = size(B);
 Blur = ones(row, col);
 
 sig2 = min(row,col)/2.5 ; 
for x = 15 : row-15
    for y = 15 : col-15
         minval = 1 ;
         for u = x-14: x+14
             for v = y-14: y+14
                 p = 1 - K(u,v)*exp( - ((v-y)^2 + (u-x)^2)/(2 * sig2 )) ;
                 if(p < minval)
                     minval = p ; 
                 end 
             end 
         end 
      
        Blur (x,y) = minval ;  
    end 
end 

for x = 1: row
    for y = 1: col
        if ((x<15)||(x>row-15)||(y<15)||(y>col-15))
            Blur(x,y) = 0;
        end
    end 
end 
% imagesc(Blur),colormap('gray');
% figure , imshowpair(B, Blur , 'montage');
% keyboard;
end

