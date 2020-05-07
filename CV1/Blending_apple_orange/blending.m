level = 6;
apple = im2double(imread('apple.jpg'));
orange = im2double(imread('orange.jpg'));
apple = imresize(apple,[size(orange,1) size(orange,2)]);

v=230;
mask = zeros(size(apple));
mask(:,1:v,:) = 1;
blur = fspecial('gauss', 30, 15);
mask = imfilter(mask,blur,'replicate');

blend = cell(1,level); 
Lapple = genPyr(apple, 'lap', level); %laplacian pyramid for image 1
Lorange = genPyr(orange, 'lap', level); %laplacian pyramid for image 2
Gmask = genPyr(mask, 'gauss', level);
for p=1:level
%    figure,imshow(Gmask{p}); 
end
for p = 1:level
	[Mp, Np, x] = size(Lapple{p});
    Gmask{p} = imresize(Gmask{p},[Mp Np]);
	blend{p} = Lapple{p}.*Gmask{p} + Lorange{p}.*(1 - Gmask{p});
end
blended_img = pyrReconstruct(blend);
figure,imshow(blended_img)

