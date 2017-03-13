im1 = imread('left.jpg');
im2 = imread('right.jpg');


if length(size(im1)) == 3
    im1 = rgb2gray(im1);
end

if length(size(im2)) == 3
    im2 = rgb2gray(im2);
end

% Make sure we are operating on single precision
im1 = im2single(im1);
im2 = im2single(im2);

img_alignment(im1, im2);