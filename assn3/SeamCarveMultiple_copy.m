function out = SeamCarveMultiple_copy(Iin, n)

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
    [I, Ix] = SeamCarve(I, Ix);
end

keyboard
Iseam = Iin;
for i=1:l
    j1 = 1;
    for j=1:b
%         display(j);
%         display(j1);
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

