function J1 = tp1(im2,Xs,Ys)

[~,b] = size(Xs);
XYs = zeros(2,b);
XYs(1,:) = Ys;
XYs(2,:) = Xs;
XYs = reshape(XYs,1,2*b);
I = im2;
J = uint8(255*zeros(size(I)));

%face: 1-10
shapeInserter = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','Custom','CustomFillColor',uint8([255 255 255]));
polygon_face = int32(XYs(1:20));
J = shapeInserter(J, polygon_face);
%eyes: 11-15 | 16-20
shapeInserter = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','Custom','CustomFillColor',uint8([0 0 0]));
polygon_eye1 = int32(XYs(21:30));
polygon_eye2 = int32(XYs(31:40));
J = shapeInserter(J, polygon_eye1);
J = shapeInserter(J, polygon_eye2);
%eyebrows: 21-24 | 25-28
shapeInserter = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','Custom','CustomFillColor',uint8([77 77 77]));%77 77 77
polygon_eb1 = int32(XYs(41:48));
polygon_eb2 = int32(XYs(49:56));
J = shapeInserter(J, polygon_eb1);
J = shapeInserter(J, polygon_eb2);
%lips: 29-36
shapeInserter = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','Custom','CustomFillColor',uint8([0 0 0]));
polygon_lips = int32(XYs(57:72));
J = shapeInserter(J, polygon_lips);
%nose: 37-40
shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom','CustomBorderColor',uint8([0 0 0]));
polygon_nose = int32(XYs(73:80));
J = shapeInserter(J, polygon_nose);

% figure, imshow(J), title('J');
J1 = rgb2gray(J);
J1 = double(J1)/255;
J1 = 1*(J1>0.5)+0.3*((J1>0.415)&(J1<0.5));
% figure, imshow(J1), title('gray J');

end