train_im = multi_load('images_train');
test_im = multi_load('images_test');
train_segment = multi_load('images_train_seg');
test_segm = multi_load('images_test_seg');

sz = size(train_im{1});

features = zeros([sz(1)*sz(2)*numel(train_im) 3]);
labels = zeros([size(features, 1) 1]);

for i = 1:numel(train_segment)
    idx = ((i-1) * (sz(1)*sz(2)))+1:(i*(sz(1)*sz(2)));
    
    segment = train_segment{i}/255; % load the first segment
%     image = rgb2hsv(train_im{i}); % load the first image
    image = train_im{i}; % load the first image

    segment = reshape(segment, [sz(1)*sz(2) 1]);
    vector = reshape(image, [sz(1)*sz(2) 3]);
    
    features(idx, :) = vector;
    labels(idx) = segment;
end

svm = fitcsvm(features, labels);
pred_segm = {};
tester_feat = zeros([sz(1)*sz(2)*numel(test_im) 3]);

tester_feat = zeros([sz(1)*sz(2)*numel(test_im) 3]);
tester_label = zeros([size(tester_feat, 1) 1]);
sz2 = size(test_im{1});
%same work as before, but using predict for our test set
for i = 1:numel(test_segm)
    idx = ((i-1) * (sz(1)*sz(2)))+1:(i*(sz(1)*sz(2)));
    
    segment = test_segm{i};
%   image = rgb2hsv(test_im{i});
    image = test_im{i};

    vec_segment = reshape(segment, [sz(1)*sz(2) 1]);
    vec_image = reshape(image, [sz(1)*sz(2) 3]);
    
    tester_feat(idx, :) = vec_image;
    tester_label(idx) = vec_segment;
    [labels, posterior] = predict(svm, tester_feat(idx, :));

    decision = posterior(:, 1) <  10*posterior(: ,2);
    
    label_pred(idx) = decision;
    pred_segm{i} = reshape(decision, [sz(1) sz(2) 1]);
    figure;
    imshow(im2double(reshape(vec_image, [sz(1) sz(2) 3])) .* pred_segm{i});
end
[labels2, scores] = predict(cf, tester_feat(1:sz(1)*sz(2),:));
% reshape(labels2, [1080 1920 3]);

[X, Y] = perfcurve(tester_label(1:sz(1)*sz(2),:),scores(:,2),1); 
figure;
plot(X,Y,'LineWidth',2);


function images2cell = multi_load(directory_name)
    files = dir(directory_name);
    images2cell = cell([length(files)-2 1]); %first two elements are .. and .
    for img=3:length(files)
        file = fullfile(files(img).folder, files(img).name);
        file = imread(file);
        images2cell{img - 2} = file;
    end
end