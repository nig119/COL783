function output = Myhisteq(im)
binranges = 0:255;
im = double(im);
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
end
