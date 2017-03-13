im1 = imread('boat1.pgm');
im2 = imread('boat2.pgm');

% Make sure images are grayscale
if length(size(im1)) == 3
    im1 = rgb2gray(im1);
end

if length(size(im2)) == 3
    im2 = rgb2gray(im2);
end

% Make sure we are operating on single precision
im1 = im2single(im1);
im2 = im2single(im2);

% im1 to im2
[M, T, ~] = RANSAC(im1, im2, 5, 3);

[matches, ka, kb] = keypoint_matchings(im1, im2);
allxy = ka(:, matches(1, :))';
% Transform allxy into the new space using the best parameters
callxy = [(M * allxy(:,[1 2])' + T)' allxy(:, [3 4])];

% Plot only some sparse samples so it becomes relatively understandable
allxy = allxy(1:20:200, :);
callxy = callxy(1:20:200, :);
plot_samples(allxy', callxy', im1, im2);

figure;

% im2 to im1
[M, T, ~] = RANSAC(im2, im1, 5, 3);

allxy = kb(:, matches(2, :))';
% Transform allxy into the new space using the best parameters
callxy = [(M * allxy(:,[1 2])' + T)' allxy(:, [3 4])];

% Plot only some sparse samples so it becomes relatively understandable
allxy = allxy(1:20:200, :);
callxy = callxy(1:20:200, :);
plot_samples(allxy', callxy', im2, im1);