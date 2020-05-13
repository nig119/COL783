blue = imread('target_n.JPG');
size_img = size(blue) ;
out = uint8(zeros(size_img));
for row = 1 : size_img(1)
    for col = 1:size_img(2)
        R = blue(row,col,1);
        G = blue(row,col,2);
        B = blue(row,col,3);
        if (abs(R - G)<5  &&  abs(G - B)<5  && B > R && B>G  && B>50 && B<230  )
        else
            out(row,col,:) = blue(row,col,:);
        end
    end 
end 

imshow (out);