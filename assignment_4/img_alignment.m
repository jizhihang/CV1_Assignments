function [ output_args ] = img_alignment(im1, im2)
N = 10;
P = 3;

% Find best transformation between input images
[best_M, best_T, ~] = RANSAC(im1, im2, N, P);

[shiftedIm, shifted_w, shifted_h, shift] = shifted_image(im1, im2, best_M, best_T);

% Nearest neighbor interpolation, use averaging
for i=2:shifted_h-1
    for j=2:shifted_w-1
        values = [shiftedIm(i-1,j-1:j+1) shiftedIm(i+1,j-1:j+1) shiftedIm(i, j-1) shiftedIm(i, j+1)];
        shiftedIm(i, j) = mean(values);
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
% Perform stitching
figure;
subplot(2, 2, 1);
imshow(shiftedIm);

% Shifting using the second image

im4 = zeros(shifted_h, shifted_w);
[im2_h, im2_w] = size(im2);
im4(shift(2) + 1:shift(2) + im2_h,shift(1) + 1:shift(1)+ im2_w) = im2;

subplot(2, 2, 2);
imshow(im4);
% 
subplot(2, 2, 3);
imshowpair(shiftedIm, im4);
%         
shiftedIm(shift(2) + 1:shift(2) + im2_h,shift(1) + 1:shift(1)+ im2_w) = im2;

subplot(2, 2, 4);
imshow(shiftedIm);
end

function [ shiftedIm, shifted_w, shifted_h, shift] = shifted_image(im1, im2, M, T)

% Shift and transform the first image, retain dimensions and shift

[img1_h, img1_w] = size(im1);

% Construct transformation
[hh, ww] = meshgrid(1:img1_h, 1:img1_w);

% Stack on one dimension, main idea is to find corners more easily.
y = reshape(hh.', 1, []);
x = reshape(ww.', 1, []);

% Stack T to be added on all dimensions
T = repmat(T', [length(x), 1]);

% Affine transformation, use ceil for rounding.
new_image_dims = int16(ceil([x;y]' * M' + T));

x = x';
y = y';

% Get boundaries
left_c = min(new_image_dims);
right_c = max(new_image_dims);

[img2_h, img2_w] = size(im2);
min_c = min([left_c; 1 1]);
max_c = max([right_c; img2_w img2_h ]);

% Determine shift
shift = 1 - min_c;

% Determine stiched dimensions.
shifted_w = max_c(1) - 1 + min_c(1);
shifted_h = max_c(2) - 1 + min_c(2);

% Shift only first image
new_image_dims = new_image_dims + repmat(shift, [length(new_image_dims), 1]);

shiftedIm = zeros(shifted_h, shifted_w);

for i=1:length(new_image_dims)
    shiftedIm(new_image_dims(i, 2), new_image_dims(i, 1)) = im1(y(i), x(i));
end

end