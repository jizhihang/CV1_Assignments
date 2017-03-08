% sigma = 3;
% window_size = 19;
% 
% img = imread('person_toy/00000001.jpg');
% kernel_size = 13;
% t = 200;
% harris(img, kernel_size, sigma, window_size, t, true);
% 
% img = imread('pingpong/0000.jpeg');
% kernel_size = 17;
% t = 3000;
% harris(img, kernel_size, sigma, window_size, t, true);

p = imread('person_toy/00000001.jpg');
harris(p, 15, 3, 10, 1, true);