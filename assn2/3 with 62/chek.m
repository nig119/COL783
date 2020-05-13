%STANDARD
subject  = imread ('subject.png');

colorTransform = makecform('srgb2lab');
lab_subject = applycform(subject, colorTransform);

subject_l = lab_subject(:,:,1) ; 
subject_a = lab_subject(:,:,2) ; 
subject_b = lab_subject(:,:,3) ; 

lab_result = lab_subject;

lab_result(:,:,1) = subject_l;
lab_result(:,:,2) = subject_a;
lab_result(:,:,3) = subject_b;

colorTransform = makecform('lab2srgb');
result = applycform(lab_result, colorTransform);

figure, imagesc(result), title('result');
