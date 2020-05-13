subject  = imread ('s.jpg');
example = imread ('e.jpg');
keyboard 
colorTransform = makecform('srgb2lab');
lab_subject = applycform(subject, colorTransform);


%% face alignment 

example_w = align(example,subject,Xs,Ys,Xp,Yp);
J1 = tp1(subject,Xs,Ys);
%make tp1 as a function
B = J1; 

%% blurring of B 
% do changes in amount of bluring and masking size
Blurred_B = Bblur (J1);

%% layer decomposition 
lab_example_w = applycform(example_w, colorTransform);

subject_l = lab_subject(:,:,1) ; 
subject_a = lab_subject(:,:,2) ; 
subject_b = lab_subject(:,:,3) ; 

example_l = lab_example_w(:,:,1) ; 
example_a = lab_example_w(:,:,2) ; 
example_b = lab_example_w(:,:,3) ; 

% wls  
subject_l = double(subject_l);
example_l = double(example_l);

subject_l_1 = subject_l./max(subject_l(:));
example_l_1 = example_l./max(example_l(:));

Blurred_B_1 = Blurred_B./max(Blurred_B(:));

% base and detail layer 
subject_s = wlsFilter(subject_l_1,Blurred_B_1, 0.2, 1.2);
subject_d =  subject_l_1 - subject_s;

%  imshowpair(subject_s , subject_d , 'montage');
%  keyboard ;

example_s = wlsFilter(example_l_1,Blurred_B_1, 0.2, 1.2);
example_d =  example_l_1  - example_s ; 

%%-------------  JUGAAD  ----------------------
imwrite((subject_s),'subject_s.PNG');
J = imread('subject_s.PNG');
subject_s = J;
imwrite((subject_d),'subject_s.PNG');
J = imread('subject_s.PNG');
subject_d = J;
imwrite((example_s),'subject_s.PNG');
J = imread('subject_s.PNG');
example_s = J;
imwrite((example_d),'subject_s.PNG');
J = imread('subject_s.PNG');
example_d = J;
%%---------------------------------------------

%  imshowpair(example_s , example_d , 'montage');
%  keyboard;

%% color layer 
subject_c_a = subject_a ;
subject_c_b = subject_b ;
 
example_c_a = example_a ; 
example_c_b = example_b ;

%% skin detail transfer 

result_d = (0.0)*subject_d + (1.0)*example_d ; 

% figure, imshow(result_d);
% keyboard;

%% C1, C2 , C3 

c1 = C1(subject,Xs,Ys);

c2 = C2(subject,Xs,Ys);

c3 = C3(subject,Xs,Ys);
[row , col] = size(subject_l);
% imshow(c1);
% keyboard;

%% color transfer 
%mistake in paper , changed c3 to c1 

result_c_a = double (zeros(row,col));
result_c_b = double (zeros(row,col));

gamma = 0.8 ; 
for x = 1: row 
    for y = 1:col
    if(c1(x,y) == 1)     
       result_c_a(x,y) = (1-gamma)*subject_c_a(x,y) + gamma* example_c_a(x,y) ; 
       result_c_b(x,y) = (1-gamma)*subject_c_b(x,y)+ gamma* example_c_b(x,y) ; 
      
    else
       result_c_a(x,y) = subject_c_a(x,y) ; 
       result_c_b(x,y) = subject_c_b(x,y) ; 
    end
    end 
end
result_c_a = uint8(result_c_a);
result_c_b = uint8(result_c_b);

% figure, imshowpair(uint8(result_c_a), uint8(result_c_b), 'montage'); 
% keyboard;

%% gradient based editing

E_s = double(example_s);
I_s = double(subject_s);
[gxE_s, gyE_s] = gradient(E_s);
[gxI_s, gyI_s] = gradient(I_s);

MagE_s = sqrt(gxE_s.^2+gyE_s.^2);
MagI_s = sqrt(gxI_s.^2+gyI_s.^2);

for i=1:row
    for j=1:col
        if (Blurred_B(i,j)*MagE_s(i,j)>MagI_s(i,j))
           gxR_s = gxE_s;
           gyR_s = gyE_s;
        else
           gxR_s = gxI_s;
           gyR_s = gyI_s;
        end
    end
end

% % R_s = poisson_solver_function(gxR_s,gyR_s,I_s);
R_s = poisson_solver_function(gxR_s,gyR_s,I_s);%CHANGED
result_s = uint8(R_s) ; 

% result_s = subject_s;


[row , col] = size(subject_l);
% result_s = double (zeros(row,col));

for x = 1: row 
    for y = 1:col
   if(c1(x,y) == 1)
       result_s(x, y ) = subject_s (x, y) ;
   end
    end 
end

figure, imshow(result_s ), title('C1 transfer'); %check the issue here 

%% lip makeup 

M = uint8 (zeros(row,col));
for x = 1: row 
    for y = 1:col
   if(c2(x,y) == 1)
       p = [x,y];
       q = perpix(p,example_l,subject_l,c2);
       M(x, y ) = example_s (q(1), q(2)) ;
   end
    end 
end
%add M to result_d/s;

% for x = 1: row 
%     for y = 1:col
%         if (M(x,y) ~= 0)
%             result_c_a(x,y) = 1.1*example_c_a(x,y);
%             result_c_b(x,y) = 1.1*example_c_b(x,y);
%         end
%     end 
% end


figure, imshow(M), title('C2 transfer'); %check the issue here 
keyboard;
%% final 

lab_result = lab_subject;

result_l = uint8(result_s + result_d) ; 
% keyboard;
%TRial
% result_l = double(result_l);
% result_1 = result_l./max(result_l(:));
% result_l = result_l.*100;
% result_l = uint8(result_l);
%TRial
result_a = result_c_a;
result_b = result_c_b;
% figure, imshowpair(result_s,result_d,'montage');
% keyboard;

lab_result(:,:,1) = result_l;  %approx
lab_result(:,:,2) = result_a;
lab_result(:,:,3) = result_b;

colorTransform = makecform('lab2srgb');
result = applycform(lab_result, colorTransform);

%figure, imagesc(result), title('result');
figure, imshowpair(subject, result,'montage'), title('result');

%% random  
%%--------------
% imwrite(uint8(result_l),'sample.PNG');
% J = imread('sample.PNG');
% figure, imshow(J), title('Jugaad');
% result_l = J;
% %%--------------
