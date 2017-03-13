function [ output_args ] = img_alignment(im1, im2)
N = 10;
P = 3;

% Find best transformation between input images
[best_M, best_T, ~] = RANSAC(im1, im2, N, P);

% Get shifted image
[shiftedIm, shifted_w, shifted_h, shift] = shifted_image(im1, im2, best_M, best_T);

% Nearest neighbor interpolation, use averaging
for i=2:shifted_h-1
    for j=2:shifted_w-1
        neighbours = [shiftedIm(i-1,j-1:j+1) shiftedIm(i+1,j-1:j+1) shiftedIm(i, j-1) shiftedIm(i, j+1)];
        shiftedIm(i, j) = mean(neighbours);
    end
end

% Plot both images next to eachother using montage
figure;
imshowpair(shiftedIm, im2, 'montage')

% 'Use the buil-in MATLAB functions imtransform and maketform'
P = zeros(3, 3);
P(1:2, 1:2) = best_M';
P(3, 3) = 1;  

% Affine transformation, alternatively can use 'affined2d')
transformed = maketform('affine', P);

% Perform final transformation
matlab_tr_img = imtransform(im1, transformed);

figure;
imshowpair(matlab_tr_img, im2, 'montage')
title('Using maketform, imtransform');

% 
%% Perform stitching
% Plot first image, shifted and transformed
figure;
subplot(2, 2, 1);
imshow(shiftedIm);

% Shifting using the second image

im4 = zeros(shifted_h, shifted_w);
[img2_h, img2_w] = size(im2);

% Corners
top_pos = shift(2) + 1;
bottom_pos = shift(2) + img2_h;
left_pos = shift(1) + 1;
right_pos = shift(1)+ img2_w;

im4(top_pos:bottom_pos,left_pos:right_pos) = im2;

% Plot second image in position
subplot(2, 2, 2);
imshow(im4);

% Show both, highlighting overlap
subplot(2, 2, 3);
imshowpair(shiftedIm, im4);

% Manually position second image in shifted image.
shiftedIm(top_pos:bottom_pos,left_pos:right_pos) = im2;
% 
subplot(2, 2, 4);
imshow(shiftedIm);
end

function [ shiftedIm, shifted_w, shifted_h, shift] = shifted_image(im1, im2, M, T)

% Shift and transform the first image, retain dimensions and shift

% Get first image dimensions
[img1_h, img1_w] = size(im1);

% Construct transformation
[hh, ww] = meshgrid(1:img1_h, 1:img1_w);

% Stack on one dimension, main idea is to apply transf more easily.
h_stacked = reshape(hh.', 1, []);
w_stacked = reshape(ww.', 1, []);

% Stack T to be added on all dimensions
T = repmat(T', [length(w_stacked), 1]);

% Apply found transformation, use ceil for rounding.
new_image_pos = int32(ceil([w_stacked;h_stacked]' * M' + T));

w_stacked = w_stacked';
h_stacked = h_stacked';

% Get boundaries
left_c = min(new_image_pos);
right_c = max(new_image_pos);

[img2_h, img2_w] = size(im2);

min_c = min([left_c; 1 1]);
max_c = max([right_c; img2_w img2_h ]);

% Determine shift
shift = 1 - min_c;

% Determine stiched dimensions.
shifted_w = max_c(1) - 1 + min_c(1);
shifted_h = max_c(2) - 1 + min_c(2);

% Shift only first image
new_image_pos = new_image_pos + repmat(shift, [length(new_image_pos), 1]);

% Create shifted image
shiftedIm = zeros(shifted_h, shifted_w);

% Add first image
for i=1:length(new_image_pos)
    shiftedIm(new_image_pos(i, 2), new_image_pos(i, 1)) = im1(h_stacked(i), w_stacked(i));
end

end
