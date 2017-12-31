function [histograms, labels] = quantize_images(image_paths, centroids, sift_type, use_dense, step_size, block_size)
% Obtains histograms and labels of images, given a set of paths.

histograms = [];
for x=1:size(image_paths)
    ds = get_features(image_paths{x}, use_dense, sift_type, step_size, block_size);
    [~, h] = visual_words(centroids, ds);
    histograms = [histograms; h];
end

labels = get_labels(image_paths);
end

function [words, h] = visual_words(centroids, descriptors)
words = zeros(1, size(descriptors,2));
for x=1:size(descriptors,2)
    [~, closest] = min(vl_alldist(single(descriptors(:,x)), centroids));
    words(1, x) = closest;
end

% Create normalized histogram
h = hist(words, size(centroids, 2));
h = h ./ max(h);
end

function [labels] = get_labels(image_paths)
labels = zeros(length(image_paths), 1);
for curr_l=1:length(image_paths)
    curr_file = image_paths(curr_l);
    
    % Get current category
    files_split = strsplit(curr_file{1}, '/');
    categ = strsplit(files_split{3}, '_');
    categ = categ{1};
    
    % Assign category at current index
    switch categ
        case 'airplanes'
            labels(curr_l) = 1;
        case 'cars'
            labels(curr_l) = 2;
        case 'faces'
            labels(curr_l) = 3;
        case 'motorbikes'
            labels(curr_l) = 4;
    end    
end

end
