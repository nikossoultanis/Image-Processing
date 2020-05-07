level = 3;
load('mask.mat');

hand = im2double(imread('hand.png'));
woman = im2double(imread('woman.png'));
hand = imresize(hand,[size(woman,1) size(woman,2)]);
mask = mask_eye;
blur = fspecial('gauss', 30, 15);
mask = imfilter(mask,blur,'replicate');
blend = cell(1,level); 
Lhand = genPyr(hand, 'lap', level); %laplacian pyramid for image 1
Lwoman = genPyr(woman, 'lap', level); %laplacian pyramid for image 2
Gmask = genPyr(mask, 'gauss', level);
for p = 1:level
	[Mp, Np, x] = size(Lhand{p});
    Gmask{p} = imresize(Gmask{p},[Mp Np]);
	blend{p} = Lwoman{p}.*Gmask{p} + Lhand{p}.*(1 - Gmask{p});
end
blended_img = pyrReconstruct(blend);
figure,imshow(blended_img)
