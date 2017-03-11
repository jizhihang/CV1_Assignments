im1 = imread('boat1.pgm');
im2 = imread('boat2.pgm');

[matches, ka, kb] = keypoint_matchings(im1, im2);

num_matches = size(matches, 2);
num_samples = 50;
samples = matches(:, randperm(num_matches, num_samples));


p1 = ka(:, samples(1, :));
p2 = kb(:, samples(2, :));
plot_samples(p1, p2, im1, im2)