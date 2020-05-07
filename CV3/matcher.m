features1 = load('photo1_feature.mat');
features2 = load('photo2_feature.mat');

features1 = features1.feature;
features2 = features2.feature;
min_iterations = min(size(features1,2), size(features2,2));
max_iterations = max(size(features1,2), size(features2,2));
matched_features = zeros(min_iterations,1);
for i = 1:max_iterations
    temp_feature = features2(:,i);
    min_ratio = 10000;
    index = -1;
    for j = 1:min_iterations
        if(matched_features(j) == 0)
            check_feat = features1(:,j);
            ratio = norm(temp_feature - check_feat, 2);
            if ratio < min_ratio
                min_ratio = ratio;
                index = j;
            end
        end
    end
    if(index < 1)
        break;
    end
    matched_features(index) = i;
end