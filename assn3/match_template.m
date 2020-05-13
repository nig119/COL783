function position = match_template(Icomplete,Ipart)
[lc,bc,~] = size(Icomplete);
[lp,bp,~] = size(Ipart);

%Calculate fourier transforms which are shifted
% P = fftshift(fft2(ifftshift((double(rgb2gray(Ipart)))),lc,bc));
P = fft2((double(rgb2gray(Ipart))),lc,bc);
% C = fftshift(fft2(ifftshift((double(rgb2gray(Icomplete))))));
C = fft2(double(rgb2gray(Icomplete)));

%Calculate correlation and its peak
% correlation = real(fftshift(ifft2(fftshift((C.*conj(P))./abs(C.*conj(P))))));
correlation = real(ifft2((C.*conj(P))./abs(C.*conj(P))));
[ypeak, xpeak] = find(correlation == max(correlation(:)));
figure, surf(correlation), shading flat; % plot correlation    

hFig = figure;
hAx  = axes;

%// New - no need to offset the coordinates anymore
%// xpeak and ypeak are already the top left corner of the matched window
position = [xpeak(1), ypeak(1), bp, lp];
figure, imshow(Icomplete, 'Parent', hAx);
imrect(hAx, position);
imshow(Ipart);
end