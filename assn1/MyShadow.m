function out = MyShadow(img)
% img = imread('tower1.PNG');
gbvs_install;
map = gbvs(img);
M = map.master_map_resized;

colorTransform = makecform('srgb2lab');
lab = applycform(img, colorTransform);
L = lab(:,:,1);

histDARK = zeros(10000,1);
histBRIGHT = zeros(10000,1);
countDARK = 0;
countBRIGHT=0;
[l,b] = size(L);
for i=1:l
    for j=1:b
        if (L(i,j)<50)
            countDARK = countDARK + 1;
            histDARK(countDARK) = L(i,j);
        else
            countBRIGHT = countBRIGHT + 1;
            histBRIGHT(countBRIGHT) = L(i,j);
        end
    end
end
histDARK = histDARK(1:countDARK);
pDARK = prctile(histBRIGHT,35);
histBRIGHT = histBRIGHT(1:countBRIGHT);
pBRIGHT = prctile(histDARK,95);

f = min(2,(pDARK/pBRIGHT));
f=3.5;

Id = double(rgb2gray(img));
Id = Id./max(Id(:));
base = wlsFilter(Id, 2, 2);
detail = Id./base;

keyboard;

baseNew = base;
F = ones(size(base));
for i=1:l
    for j=1:b
        if (L(i,j)<60)
            F(i,j) = f;
        end
    end
end
% baseNew(i,j) = f*(M(i,j))*base(i,j)+(1-M(i,j))*base(i,j);
a = ones(20,20)/400;
Fd = imfilter(F,a);
F = Fd;
baseNew = F.*(M).*base+(1-M).*base;

Idnew = baseNew.*detail;
imwrite(Idnew,'sample.PNG');
J = imread('sample.PNG');
L = J;


colorTransform = makecform('srgb2lab');
lab = applycform(img, colorTransform);
A = lab(:,:,2);
B = lab(:,:,3);
lab(:,:,1) = L;
lab(:,:,2) = A;
lab(:,:,3) = B;
colorTransform = makecform('lab2srgb');
col = applycform(lab, colorTransform);
out = col;
figure, imshow(img), title('Original');
figure, imshow(col), title('Final Color Image');

end
