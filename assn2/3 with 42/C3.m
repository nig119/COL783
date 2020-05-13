
function J1 = C3(im1,Xs,Ys)
%EYES+TEETH
[~,b] = size(Xs);
XYs = zeros(2,b);
XYs(1,:) = Ys;
XYs(2,:) = Xs;
XYs = reshape(XYs,1,2*b);

I = im1;
J = uint8(255*zeros(size(I)));

shapeInserter = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','Custom','CustomFillColor',uint8([255 255 255]));
polygon_eye1 = int32(XYs(21:30));
polygon_eye2 = int32(XYs(31:40));
J = shapeInserter(J, polygon_eye1);
J = shapeInserter(J, polygon_eye2);

% shapeInserter = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','Custom','CustomFillColor',uint8([77 77 77]));%77 77 77
% polygon_eb1 = int32(XYs(41:48));
% polygon_eb2 = int32(XYs(49:56));
% J = shapeInserter(J, polygon_eb1);
% J = shapeInserter(J, polygon_eb2);


J1 = rgb2gray(J);
J1 = double(J1)/255;
J1 = 1*(J1>0.5);
% figure, imshow(J1), title('C1');


end

