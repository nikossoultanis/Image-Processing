windmill = im2double(imread('windmill.png'));
back = im2double(imread('windmill_back.jpeg'));
mask = 1 - im2double(imread('windmill_mask.png'));

writerObj = VideoWriter('transf_windmill.avi');
writerObj.FrameRate = 24;
open(writerObj);
for frame = 1:80 %frames
    rotations = (frame / 20) * 20;
    
    rot_windmill = imrotate(windmill, rotations, 'bilinear', 'crop');
    rot_mask = 1-imrotate(mask, rotations, 'bilinear', 'crop');
    
    windmill_resized = padarray(rot_windmill,[224,384],0 ,'both');
    mask_resized = padarray(rot_mask, [224,384],1,'both');
    
    i= back .* mask_resized + windmill_resized .* (1-mask_resized);
    i = rescale(i); % normalize to 0~1
    
    writeVideo(writerObj, im2frame(i));
    
end
close(writerObj);
implay('transf_windmill.avi');