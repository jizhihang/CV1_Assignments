% Load image and make it grayscale accounting for color map
[original_image, map] = imread('Images/image1.jpeg');
if ~isempty(map)
    image = ind2gray(X,map);
end

imshow(original_image)
title('Original')

figure()

subplot(221)
filtered_image = gaussConv(original_image, 5, 5, 5);
imshow(filtered_image, [])
title('Implementation; \sigma = 5; K=5')

subplot(222)
filtered_image = imfilter(original_image, fspecial('gaussian', 5, 5));
imshow(filtered_image, []);
title('MATLAB; \sigma = 5; k=5')

subplot(223)
filtered_image = gaussConv(original_image, 11, 11, 9);
imshow(filtered_image, [])
title('Implementation; \sigma = 11; K=9')

subplot(224)
filtered_image = imfilter(original_image, fspecial('gaussian', 9, 11));
imshow(filtered_image, []);
title('MATLAB; \sigma = 3; k=3')