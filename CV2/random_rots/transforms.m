guitar = im2double(imread('guitar.jpg'));
x=1;
rot_affine = [cos(x),  sin(x), 0;
              -sin(x), cos(x), 0;
              0        0       1];
          
rot = affine2d(rot_affine);
rotated = imwarp(guitar,rot);
figure;
imshow(rotated);
figure;
imshow(guitar);