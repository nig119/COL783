img_source = imread ('source.jpg');
size_source = size(img_source) ;

img_target = imread('target.jpg');
size_target = size(img_target) ;


%% convert to lab and gray

    colorTransform = makecform('srgb2lab');
    img_source_lab = double(applycform(img_source, colorTransform));
    img_target_lab = double(applycform(img_target, colorTransform));

%     img_source_lab = rgb2lab(img_source);
%     img_target_lab = rgb2lab(img_target);
    
    target_gray = im2double(rgb2gray(img_target));
  
%% map luminance 
    % assumes that the img_source_lab is in LAB format ranging from 0-100
    % assumes that target_gray is a grayscale image ranging from 0-1
    
    img_source_l = img_source_lab(:,:,1)/100 ;
    
    source_mean = mean(img_source_l(:));
    target_mean = mean(target_gray(:));

    source_sigma = std(img_source_l(:));
    target_sigma = std(target_gray(:));
    
    source_remaped_l = (target_sigma / source_sigma) * (img_source_l - source_mean) + target_mean ; 
 
%% standard deviation neighborhood 
 
    % for source luminance 
    source_sd = zeros([size_source(1),size_source(2)]);
    source_padded = padarray(source_remaped_l , [2,2],source_mean);

    for i = 3 : size_source(1)+2
        for j = 3 : size_source(2)+2
            region = source_padded(i-2:i+2,j-2:j+2) ; 
            source_sd(i-2,j-2,1) = std (region(:));
        end
    end 

    % for target luminance 
    target_sd = zeros([size_target(1),size_target(2)]);
    target_padded = padarray(target_gray , [2,2], target_mean);

    for i = 3 : size_target(1)+2
        for j = 3 : size_target(2)+2
            region = target_padded(i-2:i+2,j-2:j+2);
            target_sd(i-2,j-2,1) = std(region(:));
        end
    end 
    
 imshowpair(source_sd,target_sd,'montage');
%% convert to a column matrix for minimisation 

    source_column = [source_remaped_l(:),source_sd(:)];
    target_column = [target_gray(:), target_sd(:)];
    

    output = zeros(size_target);
    output(:,:,1) = img_target_lab(:,:,1); 
    for j = 1 : size_source(2)
        for i = 1:size_source(1)

            R = img_source(i,j,1);
            G = img_source(i,j,2);
            B = img_source(i,j,3);

            idx = i + (j-1)*size_source(1);
            
            size_source_col = size(source_column); 
            enlarged_target = repmat(target_column(idx,:), size_source_col(1), 1);
            square_diff = (enlarged_target - source_column).^2;
            weighted_sum = 0.5 * square_diff(:, 1) + 0.5 * square_diff(:, 2);
            [~, best_match] = min(weighted_sum);

            new_j = ceil(best_match/size_source(1));
            new_i = best_match - (new_j-1)*size_source(1);

%             display(new_i);
%             display(new_j);
%             display(size(output));
%             display(size(img_source_lab));
            
            
            if (abs(R - G)<5  &&  abs(G - B)<5  && B > R && B>G  && B>50 && B<230  )
                output(i,j,2:3) = img_source_lab(new_i,new_j,2:3);
            else
                output(i,j,2:3) = img_target_lab(i,j,2:3);
            end
            %a = output(i,j,2:3);
        end 
    end
%     
% colorTransform = makecform('srgb2lab');
% lab = applycform(im2, colorTransform);
% A = lab(:,:,2);
% B = lab(:,:,3);


%% display 
colorTransform = makecform('lab2srgb');
out_rgb = applycform(output, colorTransform);

% out_rgb = lab2rgb(output);

