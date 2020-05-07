image = imread('pudding.png');
frame_count = 100;

speed = 10;
ampl = 0.4;

for frame = 1:0.3:frame_count
    shear = ampl * sin((frame / frame_count) * (2 * speed *pi));
    transform = affine2d([1 0 0; shear 1 0; 0 0 1]);
    sheared = imwarp(image, transform);
    sheared = padarray(sheared,[300,300],0,'both');
    sheared = imresize(sheared,[300,300]);
    imshow(sheared);
end