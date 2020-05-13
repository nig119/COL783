function [ b ] = gauss( a )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

a = abs(a);
sd = 0.5 ; 
b = 1/(2*pi*sd)*exp(-(a).^2/(2*sd^2));


end

