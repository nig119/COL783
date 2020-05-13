function [ q ] = perpix( p , e_l , i_l , f )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[row , col] = size(e_l);

q = [1,1]; 
max = 0 ; 
for x = 1: row 
    for y = 1:col
   if(f(x,y) == 1)
       k =  gauss( abs(sqrt((p(1)-x)^2 + (p(2)-y)^2))) * gauss(abs(e_l(p(1),p(2))-i_l(x,y)));
       if(k > max)
           max = k ; 
            q = [x,y];
       end 
   end
    end 
end


end

