%-------------- Adjusted Image (Luminance Channel) -----------------------%
function [d,b,m] = Bimodal(skin)

I = double(rgb2gray(skin));
I = I./max(I(:));
%res = wlsFilter(I, 0.5);
%figure, imshow(I), figure, imshow(res)
res = wlsFilter(I, 2, 2);
%figure, imshow(res);

%imhist(res);
avg = mean(imhist(res));
hist = imhist(res);
hist1 = hist;

a = [(1/256):(1/256):1];
a = reshape(a,256,1);

hist1(hist1<0.5*avg) = 0;
hist1(hist1>1.5*avg) = 1;
hist1((hist1>0.5*avg)&(hist1<1.5*avg)) = 0.5;

d = 1000;
m = 1000;
b = 1000;

[n,~] = size(hist1);
for i=1:n
    if (hist1(i)==1)
        d = i;
        break;
    end
end

for j=i:n
    if (hist1(j)==0)
        m = j;
        break;
    end
end

for i=j:n
    if (hist1(i)==1)
        b = i;
        break;
    end
end

end

