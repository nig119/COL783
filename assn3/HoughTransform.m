function [Rtable,img2] = HoughTransform(object,Iin)
object_copy = zeros(size(object));
object = double(object);
%% Generate R Table for object image

% Define reference point
[l,b] = size(object);
[li,bi,~] = size(Iin);
ic = floor(l/2);
jc = floor(b/2);

%Define R-table
Rtable = zeros(360,3);

%Gradient angle
[O_x, O_y] = gradient(object);
T  = O_y./O_x;
object_grad = abs(O_x)+abs(O_y);
object = object_grad;
Phi = atan(T);
max_og = max(object(:));

% Vary alpha by 10 degrees. So 36 entries in the R table
for ad=1:360
    alphaD = ((2*pi*ad)/360);
%     alpha = pi-alphaD;
    alpha = alphaD;
    Rtable(ad,1) = alpha;
    xint = -1;
    yint = -1;
    m = tan(alpha);
    i=ic;
    j=jc;
%     display(10*ad);
    while(i>0 && j>0 && i<=l && j<=b) %&& object_copy(i+15,j+15) == 0)
        
        if (object(i,j)>=max_og/2)
            object_copy(i,j) = 255;
            xint = i;
            yint = j;
        end
        if (m>=-1  && m <= 1)
            if ((0<ad && ad<=45) || (315<ad && ad<=360))
                j=j+1;
            else
                j=j-1;
            end
            i = floor( -m*(j-jc) ) + ic;
        else 
            if ( ad>45 && ad<=135)
                i = i-1; 
            else
                i = i+1;                 
            end
            j = floor( -(i-ic)/m ) + jc;
        end
        
    end
    if (xint==-1)
        r = -1;
        phi = 0;
    else
        r = sqrt((xint-ic)^2 + (yint-jc)^2);
        phi = Phi(xint,yint);
    end
    Rtable(ad,2) = r;
    Rtable(ad,3) = phi;
    imshow(object_copy);
    pause(0.05);
end
% keyboard;
%% Detection in Iin

%construct I1
I1 = double(Iin);
% I1 = rgb2gray(I1);

[I1_x,I1_y] = gradient(I1);
I = abs(I1_x)+abs(I1_y);
mx = max(I(:));
I=255*(I>=mx/2);
% imagesc(I);

% Detection table
Det = zeros(li,bi,360,10);

%Phi of each pixel in image I
I_phi = atan(I1_y./I1_x);
% figure, imagesc(I_phi);
img = zeros(li,bi);

% keyboard;
for i=1:li
%     display(i);
    for j=1:bi
%         display(j);
        container = zeros(360,3);
        index = 1;
        if (I(i,j)==255)
            %For each point now (i,j) Using gradient angle phi retrieve
            %(R,alpha) using phi value
            phi_I = I_phi(i,j);
            mini=1e9;
            for k=1:360
                mi = abs(Rtable(k,3)-phi_I);
%                 display(mi);
                container(k,1) = mi;
                container(k,2) = Rtable(k,1);
                container(k,3) = Rtable(k,2);
                %if (mi<mini)
                 %   mini = mi;
                  %  alpha_I = Rtable(k,1);
                   % r_I = Rtable(k,2);
                %end    
            end        
            container = sort(container,1);
%             keyboard;
            
            %now look in 4D space
            k = 1;
            while(container(k,1) < 0.1) 
                r_I = container(k,3);
                if (r_I > 0)
                    alpha_I = container(k,2);
                    xc_copy = i - (r_I*(cos(alpha_I)));
                    yc_copy = j - (r_I*(sin(alpha_I)));
                    if (xc_copy>1 && yc_copy>1 && xc_copy<=li && yc_copy<=bi) 
                        img(floor(xc_copy),floor(yc_copy)) = 1 + img(floor(xc_copy),floor(yc_copy));
                    end;
                end;
                k = k+1;
            end;
%             for th=36:36
%                 theta = (2*pi*th)/36;
%                 for sd=5:5
%                     s = 2^(sd-5);
%                     xc_copy = floor(i - (r_I*(cos(theta+alpha_I)))*(s));
%                     yc_copy = floor(j - (r_I*(sin(theta+alpha_I)))*(s));
%                     xc_copy
%                     yc_copy
%                     img(xc_copy,yc_copy) = 255;
%                     Det(xc_copy,yc_copy,th,sd) = Det(xc_copy,yc_copy,th,sd) + 1; 
%                     if (xc_copy>0 && yc_copy>0 && xc_copy<=bi && yc_copy<=li)                     
%                         Det(xc_copy,yc_copy,th,sd) = Det(xc_copy,yc_copy,th,sd) + 1;
%                     end
%                 end
%             end
            
        end
        
    end
end
img=255*(img>=5);
img2=uint8(img);
figure, imagesc(uint8(img)), title('Centers');

keyboard;

%%

end