function out = MyEnhance(im)


%% -------------------- Detected fact rectangle -------------------------%%
faceDetector = vision.CascadeObjectDetector;
Id = im;
bboxes = step(faceDetector, Id);
% Ijstart = bboxes(1);
% Iistart = bboxes(2);
% Ijend = bboxes(3)+Ijstart;
% Iiend = bboxes(4)+Iistart;

Ijstart = 161;Iistart = 94;Ijend = 312;Iiend = 296; %actress5.PNG girl
% Ijstart = 219;Iistart = 126;Ijend = 340;Iiend = 282; %actress4.PNG girl with glasses
% Ijstart = [97,491,847];Iistart = [86,115,127];Ijend = [255,660,1023];Iiend = [313,360,295]; %actors1.PNG first man 
% Ijstart = 72;Iistart = 97;Ijend = 401;Iiend = 574; %actress6.PNG  woman with glasses & eyes closed

% %% ------- CIELAB conversion. A and B matrices used ---------------------%%
% colorTransform = makecform('srgb2lab');
% lab = applycform(im2, colorTransform);
% A = lab(:,:,2);
% B = lab(:,:,3);

%% ---------- HSV conversion. H and s matrices used ---------------------%%
hsv = rgb2hsv(im);
H = hsv(:,:,1);
s = hsv(:,:,2);

%-------------------------------- Skin Mask ------------------------------%
%% -- Detect if it lies in the ellipse formed and classify as skin ------%%
im3 = uint8(ones(size(im)))*255;
[~, faces] = size(Ijstart);
p=zeros(1,faces);
for k=1:faces    
    im2 = im(Iistart(k):Iiend(k),Ijstart(k):Ijend(k),:);    
    [l,b,~] = size(im2);
    colorTransform = makecform('srgb2lab');
    lab = applycform(im2, colorTransform);
    A = lab(:,:,2);
    B = lab(:,:,3);
    count = 0;
    Igray = rgb2gray(im2);
    hist3 = zeros(10000,1);
    for i=1:l
        for j=1:b
            if (  ( ( (143-A(i,j)) /6.5)^2 + ((148-B(i,j))/12)^2 )  <  6)
                if ( (s(i,j)>=0.25) && (s(i,j)<=0.75) && (H(i,j)<= 0.095) )
                %if ( (H(i,j)<=0.095) )
                    %im3(i,j,:) = im2(i,j,:);
                    im3(i+Iistart(k),j+Ijstart(k),:) = im2(i,j,:);
                else
                    %im3(i,j,:) = [255,255,255];
                    im3(i+Iistart(k),j+Ijstart(k),:) = im2(i,j,:);
                end
                count = count + 1;
                hist3(count) = Igray(i,j);
            else
                %im3(i,j,:) = [255,255,255];
                im3(i+Iistart(k),j+Ijstart(k),:) = [255,255,255];
            end
        end
    end
    hist3 = hist3(1:count);
    p(k) = prctile(hist3,50);
    display(p(k));
end
skin = im3;
figure, imshow(skin), title('Skin');

display(count);
%% ----------- Adjusted Image (Luminance Channel) -----------------------%%
%colorTransform = makecform('srgb2lab');
%lab = applycform(im, colorTransform);

Id = double(rgb2gray(im));
Id = Id./max(Id(:));
Iout = wlsFilter(Id, 2, 2);
detail = Id./Iout;
% figure, imshow(Iout), title('Base Layer');

% %% --------------------- Bimodal Values -------------------------------- %%
% grayskin = rgb2gray(skin);
% hist1 = imhist(grayskin);
% hist1 = hist1(1:255);
% pts = (1:1:255);
% % [maxtab, mintab] = peakdet(hist1, 250, pts);
% [f,~] = ksdensity(hist1,'npoints',256);
% f = reshape(f,[256,1]);
% f = f(1:255);
% [maxtab, mintab] = peakdet(f, 3e-4, pts);
% [lmax,~] = size(maxtab);
% [lmin,~] = size(mintab);
% d=300;m=300;b=300;
% for i=1:lmax-1
%     for j=1:lmin
%         if ((maxtab(i,1)<mintab(j,1))&&(maxtab(i+1,1)>mintab(j,1)))
%             d = maxtab(i,1);
%             m = mintab(j,1);
%             b = maxtab(i+1,1);
%             break;
%         end
%     end
% end
% 
% display(d);
% display(m);
% display(b);
%% --------------------- Sidelight Correction ---------------------------%%
%[d,b,m] = Bimodal(skin);
d=44;m=70;b=80; %actress5.PNG girl
% d=300;m=300;b=300; %actress4.PNG girl with glasses
% d=[40,20,30];m=[100,40,60];b=[125,60,80]; %actors1.PNG first man
% d=65;m=115;b=130; %actress6.PNG  woman with glasses & eyes closed
% % d=53;m=80;b=146; %actress6.PNG  woman with glasses & eyes closed
% % d=75;m=95;b=130; %actress6.PNG  woman with glasses & eyes closed

display(d);
display(m);
display(b);
keyboard;

A = ones(size(Iout));
Igray = double(rgb2gray(im));
for k=1:faces    
    if ((d(k)<255)||(b(k)<255)||(m(k)<255))
        f = (b-d)/(m-d);
        display(f);
        for i=Iistart(k):Iiend(k)
            for j=Ijstart(k):Ijend(k)
                if ((skin(i,j,1)<255)&&(skin(i,j,1)<255)&&(skin(i,j,1)<255))
                    if (Igray(i,j)<m(k))    
                        A(i,j) = f;
                    end
                end
            end
        end
        %A = localcontrast(uint8(A),0.4,-0.35);
    end
end
figure, imagesc(A), title('Double A');
a = ones(20,20)/400;
Ad = imfilter(A,a);
figure, imagesc(Ad), title('Double A + Blurring');
A = Ad;
%
%% ------------ Pixelwise multiplication of Iout and A ------------------%%
%mx1 = max(Iout(:));
Iout = Iout.*A;
%mx2 = max(Iout(:));    
% figure, imshow(Iout), title('Sidelight Correction');

% %% ----------------------75th percentile calculation ------------------- %%
% grayskin = rgb2gray(skin);
% % figure, imshow(grayskin), title('Skin (Gray)');
% hist3 = zeros(count,1);
% h=1;
% [l,b,~] = size(im);
% for h=1:faces    
%     for i=1:l
%         for j=1:b
%             if (grayskin(i,j)~=255)
%                 hist3(k) = grayskin(i,j);
%                 k=k+1;
%             end
%         end
%     end
% end
% hist3 = hist3(1:k-1);
% p = prctile(hist3,50);
% display(p);
%% ------------------------ Exposure correction -------------------------%%
grayskin = rgb2gray(skin);

%p = prctile(grayskin(:),75);
A1 = ones(size(Iout));
%display(p);
for k=1:faces   
    if (p(k)<125)
        display('yes');
        f = (125+p(k))/(3*p(k));
        if (f<1)
            f=1;
        else if (f>2)
                f=2;
            end
        end
        display(f);
        % f=1.07;
        for i=Iistart(k):Iiend(k)
            for j=Ijstart(k):Ijend(k)
                if (grayskin(i,j)<255)
                    A1(i,j)=f;
                end
            end
        end
    end
end
figure, imagesc(A1), title('A for exposure correction');
a = ones(40,40)/1600;
Ad1 = imfilter(A1,a);
figure, imagesc(Ad1), title('A for exposure correction smoothed');
A1 = Ad1;
Iout = Iout.*A1;
figure, imshow(Iout), title('Exposure Correction');
%% --------------------
Iout = (Iout.*detail);
% out = Iout;
%figure, imshow(out), title('Iout');
% figure, imshow(Iout), title('Details added');
imwrite(Iout,'sample.PNG');
J = imread('sample.PNG');
% figure, imshow(J), title('Jugaad');

L = Iout/(max(Iout(:)));
L = uint8(L*255);

L = J;

%% -------------------- Adding back details and color -------------------%%
colorTransform = makecform('srgb2lab');
lab = applycform(im, colorTransform);
A = lab(:,:,2);
B = lab(:,:,3);
lab(:,:,1) = L;
lab(:,:,2) = A;
lab(:,:,3) = B;
colorTransform = makecform('lab2srgb');
col = applycform(lab, colorTransform);
out = col;
figure, imshow(im), title('Original');
figure, imshow(col), title('Final Color Image');
%keyboard
%% -------------------------- End ---------------------------------------%%
end

