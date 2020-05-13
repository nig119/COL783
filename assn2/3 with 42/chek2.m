%STANDARD
subject  = imread ('subject.png');
example = imread ('example.png');
example_w = align(example,subject,Xs,Ys,Xp,Yp);
tp1;
B = J1; 
% blurring of B 
Blurred_B = Bblur (J1);

colorTransform = makecform('srgb2lab');
lab_subject = applycform(subject, colorTransform);

subject_l = lab_subject(:,:,1) ; 
subject_a = lab_subject(:,:,2) ; 
subject_b = lab_subject(:,:,3) ; 

lab_example_w = applycform(example_w, colorTransform);

example_l = lab_example_w(:,:,1) ; 
example_a = lab_example_w(:,:,2) ; 
example_b = lab_example_w(:,:,3) ; 


% wls  
subject_l = double(subject_l);
example_l = double(example_l);

subject_l_1 = subject_l./max(subject_l(:));
example_l_1 = example_l./max(example_l(:));

Blurred_B = Blurred_B./max(Blurred_B(:));

% base and detail layer 
subject_s = wlsFilter(subject_l_1,Blurred_B, 0.2, 1.2);
subject_d =  subject_l_1 - subject_s;
example_s = wlsFilter(example_l_1,Blurred_B, 0.2, 1.2);
example_d =  example_l_1  - example_s ; 

%--------------
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
%%--------------

% skin detail transfer 
result_d = (0.0)*subject_d + (1.0)*example_d ; 

%gradient
result_s = subject_s ; 

%labspace L
result_l = uint8(result_s + result_d) ;




%STANDARD
lab_result = lab_subject;

lab_result(:,:,1) = subject_l;
lab_result(:,:,2) = subject_a;
lab_result(:,:,3) = subject_b;

colorTransform = makecform('lab2srgb');
result = applycform(lab_result, colorTransform);

figure, imagesc(result), title('result');
