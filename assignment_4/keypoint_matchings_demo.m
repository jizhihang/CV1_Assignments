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

[matches, ka, kb] = keypoint_matchings(im1, im2);

num_matches = size(matches, 2);
num_samples = 50;
samples = matches(:, randperm(num_matches, num_samples));


p1 = ka(:, samples(1, :));
p2 = kb(:, samples(2, :));
plot_samples(p1, p2, im1, im2)