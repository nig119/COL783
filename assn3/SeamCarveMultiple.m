function out = SeamCarveMultiple(Iin,position)

if nargin == 1
    imshow(Iin);
    position = getrect;
end
n = position(3);
position(1) = floor(position(1));
position(2) = floor(position(2));
position(3) = floor(position(1)+position(3));
position(4) = floor(position(2)+position(4));

%To know which pixels actually remain till the end, this is my jugaad
[l,b,~] = size(Iin);
Ix = zeros(l,b);
for i=1:l
    for j=1:b
        Ix(i,j) = j;
    end
end

I = Iin;
for i=1:n
    i
    [I, Ix] = SeamCarve(I, Ix, position);
end

keyboard
Iseam = Iin;
for i=1:l
    j1 = 1;
    for j=1:b
        if (j1>b-n)
            Iseam(i,j,1) = 255;
            Iseam(i,j,2) = 0;
            Iseam(i,j,3) = 0;
        elseif (Ix(i,j1)==j)
            j1 = j1 + 1;
        else
            Iseam(i,j,1) = 255;
            Iseam(i,j,2) = 0;
            Iseam(i,j,3) = 0;
        end
    end
end



str = 'Seams Carved = ';
str = strcat(str, num2str(n));

out = I;
figure, imagesc(out), title(str);
figure, imagesc(Iseam), title('Highlighting removed seams');

