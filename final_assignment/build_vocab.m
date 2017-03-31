function [ centroids ] = build_vocab(dataset, voc_size, use_dense, feature_extr)
% Construct the visual vocabulary given a dataset of image paths.
% Extracts descriptors from each image given the specified feature
% extractor, stacks them and applies k-means clustering to obtain
% centroids.

% Obtain stacked descriptors
descriptors = [];
for k=1:length(dataset)
   img_path = dataset{k};
   ds = get_features(img_path, use_dense, feature_extr);
   descriptors = [descriptors ds];
end

% Obtain centrods
[centroids, ~] = vl_kmeans(single(descriptors), voc_size);

end

