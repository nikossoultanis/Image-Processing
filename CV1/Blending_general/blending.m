level = 3;
blend = cell(1,level); 
blur = fspecial('gauss', 30, 15);
%INPUTS
bench = im2double(imread('bench.jpg'));
p200 = im2double(imread('P200.jpg'));
dog1 = im2double(imread('dog1.jpg'));
dog2 = im2double(imread('dog2.jpg'));
cat  = im2double(imread('cat.jpg'));
me = im2double(imread('me.JPG'));
load('me_mask.mat');
load('bench_mask.mat');
load('cat_mask.mat');
load('dog1_mask.mat');
load('dog2_mask.mat');

Lp200 = genPyr(p200, 'lap', level); %laplacian pyramid for image 2.

%IMAGE 1
person_mask = me_mask;
me = me.*person_mask;
me = imresize(me, [1280 960]);
person_mask = imresize(person_mask, [1280 960]);
blur = fspecial('gauss', 30, 15);
%Zero padding for image and mask
smaller_me = zeros(2448, 3264, 3);
smaller_me(1169:2448, 2305:3264, :) = me;
smaller_me_mask = zeros(2448,3264);
smaller_me_mask(1169:2448, 2305:3264, :) = person_mask;
smaller_me_mask = imfilter(smaller_me_mask,blur,'replicate');
%pyramids
Lme = genPyr(smaller_me, 'lap', level);
Gmemask = genPyr(smaller_me_mask, 'gauss', level);

%-------IMAGE 2------------
bench_mask = imfilter(bench_mask,blur,'replicate');

%resizing the bench.
smaller_bench = imresize(bench,0.2);
final_bench = zeros(2448,3264,3) ;
final_bench(1800:2289,1000:1652,:) = smaller_bench ;
Lbench = genPyr(final_bench, 'lap', level); %laplacian pyramid for image 1.

%resizing the bench mask.
smaller_mask = imresize(bench_mask,0.2);
final_mask = zeros(2448,3264);
final_mask(1800:2289,1000:1652) = smaller_mask ;
Gmask = genPyr(final_mask, 'gauss', level);


%-------IMAGE 3------------
%resizing the dog1
smaller_dog1 = imresize(dog1, 0.2);
final_dog1 = zeros(2448,3264,3);
final_dog1(1959:2448, 2612:3264,:) = smaller_dog1;
Ldog1 = genPyr(final_dog1, 'lap', level);

%resizing dog1 mask
smaller_dog1_mask = imresize(dog1_mask, 0.2);
final_dog1_mask = zeros(2448, 3264);
final_dog1_mask(1959:2448, 2612:3264) = smaller_dog1_mask;
Gdog1mask = genPyr(final_dog1_mask, 'gauss', level);

%-------IMAGE 4------------
%resizing the dog2
smaller_dog2 = imresize(dog2, 0.2);
final_dog2 = zeros(2448, 3264, 3);
final_dog2(1959:2448, 1:653, :) = smaller_dog2;
Ldog2 = genPyr(final_dog2,'lap', level);
%resizing dog2 mask
smaller_dog2_mask = imresize(dog2_mask, 0.2);
final_dog2_mask = zeros(2448, 3264);
final_dog2_mask(1959:2448, 1:653) = smaller_dog2_mask;
Gdog2mask = genPyr(final_dog2_mask, 'gauss', level);


%-------IMAGE 5------------
%resizing the cat
smaller_cat = imresize(cat, 0.2);
final_cat = zeros(2448,3264,3);
final_cat(1:490, 1:653, :) = smaller_cat;
Lcat = genPyr(final_cat, 'lap', level);
%resizing cat mask
smaller_cat_mask = imresize(cat_mask, 0.2);
final_cat_mask = zeros(2448,3264);
final_cat_mask(1:490, 1:653) = smaller_cat_mask;
Gcatmask = genPyr(final_cat_mask, 'gauss', level);

for p = 1:level
	[M, N, x] = size(Lbench{p});
    Gdog1mask{p} = imresize(Gdog1mask{p}, [M N]);
    Gdog2mask{p} = imresize(Gdog2mask{p}, [M N]);
    Gcatmask{p}  = imresize(Gcatmask{p}, [M N]);
    Gmask{p} = imresize(Gmask{p},[M N]);
    Gmemask{p} = imresize(Gmemask{p}, [M N]);
	blend{p} = Lp200{p}.*(1 - Gmask{p}).*(1 - Gmemask{p}).*(1 - Gdog1mask{p}).*(1 - Gdog2mask{p}).*(1 - Gcatmask{p}) ...
    + Lbench{p}.*Gmask{p} + Lme{p}.*Gmemask{p} + Ldog1{p}.*Gdog1mask{p} + Ldog2{p}.*Gdog2mask{p} + Lcat{p}.*Gcatmask{p};
end
blended_img = pyrReconstruct(blend);
figure,imshow(blended_img);