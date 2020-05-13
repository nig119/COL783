function transferred = image_colorization(target, csource, GRAPH)
    jittered = sampling(csource.luminance, csource.lab, 256);
    if GRAPH
        imshow(csource.image);
        hold on;
        scatter(jittered.points(:,2), jittered.points(:,1), 'r');
    end
    target.sds = sd_neighborhood(target.luminance, 5);
    target.fv = [target.luminance(:), target.sds(:)];
    transferred = transfer_sample_fv(jittered, target);
end