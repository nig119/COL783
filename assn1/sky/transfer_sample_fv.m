function transferred = transfer_sample_fv(jittered, target)
    target_fv = target.fv;
    transferred = zeros(size(target.image));
    transferred(:, :, 1) = target.lab;
    [c_y, c_x] = size(target.lab);
    
        
    img_source = imread('target.JPG');
    img_lab = rgb2lab(img_source);
    
    
    for j = 1:c_x
        for i = 1:c_y
            idx = (i-1) + (j-1)*c_y + 1;
            best_match = compute_best_match(target_fv(idx, :), jittered.fv);
            
             R = img_source(i,j,1);
            G = img_source(i,j,2);
            B = img_source(i,j,3);
            
            if (abs(R - G)<5  &&  abs(G - B)<5  && B > R && B>G  && B>50 && B<230  )
                transferred(i, j, 2:3) = jittered.ab(best_match, :);
            else 
                transferred(i, j, 2:3) = img_lab(i, j, 2:3);
            end 
%              transferred(i, j, 2:3) = jittered.ab(best_match, :);
        end
    end
    transferred(:,:,1) = transferred(:,:,1) * 100;
end