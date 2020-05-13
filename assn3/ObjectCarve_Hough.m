function out = ObjectCarve_Hough(Iin,Ipart,n)
Ipart = rgb2gray(Ipart);
[Rtable,img] = HoughTransform(Ipart,Iin);
% Rtable = h(1);
% img = h(2);
[l1,b1]=size(img);
keyboard

Iin = double(Iin);
R = Iin(:,:,1);
G = Iin(:,:,2);
B = Iin(:,:,3);

%To know which pixels actually remain till the end, this is my jugaad
[l,b,~] = size(Iin);
Ix = zeros(l,b);
for i=1:l
    for j=1:b
        Ix(i,j) = j;
    end
end


%% Energy Function
[R_x,R_y] = gradient(R);
[G_x,G_y] = gradient(G);
[B_x,B_y] = gradient(B);
[l,b,~] = size(Iin);

E = abs(R_x) + abs(R_y) + abs(G_x) + abs(G_y) + abs(B_x) + abs(B_y);
E = E+1e5;
%%

Ienergy = zeros(size(E));
keyboard
for i=1:l1
    for j=1:b1
        if (img(i,j) == 255)
            for k = 1:360
                xc = floor(i + Rtable(k,2)*cos(Rtable(k,1)));
                yc = floor(j + Rtable(k,2)*sin(Rtable(k,1)));
                Ienergy(xc,yc) = 255;
            end
        end
    end
end

%%
% n=50;
Id = Iin;
for g=1:n
    g
    [Id, Ix, Ienergy] = SeamCarveEnergy(Id,Ix,Ienergy);
end

%%

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

out = Id;
figure, imshow(uint8(out)), title(str);
figure, imshow(uint8(Iseam)), title('Highlighting removed seams');



