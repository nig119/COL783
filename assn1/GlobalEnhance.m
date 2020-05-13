function out = GlobalEnhance(img)
% out = histeq(img);

colorTransform = makecform('srgb2lab');
lab = applycform(img, colorTransform);
L = lab(:,:,1);
A = lab(:,:,2);
B = lab(:,:,3);

binranges = 0:255;
im = double(L);
counts = histc(im,binranges);
cdf = cumsum(counts)/sum(counts);
cdfScaled = floor(cdf*255);
[m,n] = size(im);
output = zeros(m,n);
for i=1:m
    for j=1:n
        output(i,j) = cdfScaled(im(i,j)+1);
    end
end

lab(:,:,1) = output;
lab(:,:,2) = A;
lab(:,:,3) = B;
colorTransform = makecform('lab2srgb');
col = applycform(lab, colorTransform);
out = col;

end

