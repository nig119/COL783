function [out, outIx] = SeamCarve(Iin, Ix, position)
Iin = double(Iin);
R = Iin(:,:,1);
G = Iin(:,:,2);
B = Iin(:,:,3);

%% Energy Function
[R_x,R_y] = gradient(R);
[G_x,G_y] = gradient(G);
[B_x,B_y] = gradient(B);
[l,b,~] = size(Iin);

E = abs(R_x) + abs(R_y) + abs(G_x) + abs(G_y) + abs(B_x) + abs(B_y);

%% Change Energy function to carve out object
E = E+1e5;
start_i = position(2);
start_j = position(1);
end_i = position(4);
end_j = position(3);

[~,b1] = size(Ix);
for i=start_i:end_i
    for j=1:b1
%     for j=start_j:end_j;
       if (Ix(i,j)>=start_j&&Ix(i,j)<=end_j)
           E(i,j) = 0;
%         E(i,j) = 0;
       end
    end
end
% figure, imagesc(E), title('Energy Function');

%% Make the matrix using DP
SC = E;
% Directions: 
% Upper Left: 1, Upper: 2, Upper Right: 3
Directions = zeros(size(E));
for i=2:l
    for j=1:b
        a1 = 1e20;
        if (j>1)
            a1 = SC(i-1,j-1);
        end
        a2 = SC(i-1,j);
        a3 = 1e20;
        if (j<b)
            a3 = SC(i-1,j+1);
        end
        a = min(min(a1,a2),a3);
        if (a==a1)
            d = 1;
        elseif (a==a2)
            d = 2;
        elseif (a==a3)
            d = 3;
        end
        SC(i,j) = SC(i,j)+a;
        Directions(i,j) = d;
    end
end

% figure, imagesc(SC), title('DP Matrix for Seam Carving');

%% Seam Carve the minimum energy seam

% Get the pixel in last column which has least energy value
i=l;
minm = 1e20;
J = 0;
for j=1:b
    if (SC(i,j)<minm)
        J = j;
        minm = SC(i,j);
    end
end

% Carve out the seam
for ir=1:l
    i = l+1-ir;
    SC(i,J) = 1e20;
    if (Directions(i,J)==1)
        J = J-1;
    elseif (Directions(i,J)==2)
        J = J;
    elseif (Directions(i,J)==3)
        J = J+1;
    end
end

% figure, imagesc(SC), title('DP Matrix after Seam Carving');

%% Reduce the breadth of image by 1 by removing the seam

I = zeros(l,b-1,3);
outIx = zeros(l,b-1);
for i=1:l
    j1 = 1;
    for j=1:b
        if (SC(i,j)==1e20)
            j1 = j1;
        else
            I(i,j1,1) = Iin(i,j,1);
            I(i,j1,2) = Iin(i,j,2);
            I(i,j1,3) = Iin(i,j,3);
            outIx(i,j1) = Ix(i,j);
            j1 = j1+1;
        end
    end
end

out = uint8(I);
% keyboard;
% figure, imagesc(out), title('Seam Carved Image');
end





