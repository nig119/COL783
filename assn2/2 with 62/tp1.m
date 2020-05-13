function J1 = tp1(im2,Xs,Ys)

[~,b] = size(Xs);
XYs = zeros(2,b);
XYs(1,:) = Ys;
XYs(2,:) = Xs;
XYs = reshape(XYs,1,2*b);
I = im2;
J = uint8(255*zeros(size(I)));

%face: 1-15
shapeInserter = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','Custom','CustomFillColor',uint8([255 255 255]));
polygon_face = int32(XYs(1:30));
J = shapeInserter(J, polygon_face);
%eyes: 16-21 | 22-27
shapeInserter = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','Custom','CustomFillColor',uint8([0 0 0]));
polygon_eye1 = int32(XYs(31:42));
polygon_eye2 = int32(XYs(43:54));
J = shapeInserter(J, polygon_eye1);
J = shapeInserter(J, polygon_eye2);
%eyebrows: 28-33 | 34-39
shapeInserter = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','Custom','CustomFillColor',uint8([77 77 77]));%77 77 77
polygon_eb1 = int32(XYs(55:66));
polygon_eb2 = int32(XYs(67:78));
J = shapeInserter(J, polygon_eb1);
J = shapeInserter(J, polygon_eb2);
%lips: 40-46 | 47-53
shapeInserter = vision.ShapeInserter('Shape','Polygons','Fill',true,'FillColor','Custom','CustomFillColor',uint8([0 0 0]));
polygon_lip1 = int32(XYs(79:92));
polygon_lip2 = int32(XYs(93:106));
J = shapeInserter(J, polygon_lip1);
J = shapeInserter(J, polygon_lip2);
%nose: 54-62
shapeInserter = vision.ShapeInserter('Shape','Lines','BorderColor','Custom','CustomBorderColor',uint8([0 0 0]));
polygon_nose = int32(XYs(107:124));
J = shapeInserter(J, polygon_nose);

% figure, imshow(J), title('J');
J1 = rgb2gray(J);
J1 = double(J1)/255;
J1 = 1*(J1>0.5)+0.3*((J1>0.415)&(J1<0.5));
% figure, imshow(J1), title('gray J');

end