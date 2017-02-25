% Load image and make it grayscale accounting for color map
[X, map] = imread('Images/image1.jpeg');
if ~isempty(map)
    image = ind2gray(X,map);
end

new_image = gaussDer(X, gauss(5, 5), 5);
imshow(new_image, []);

