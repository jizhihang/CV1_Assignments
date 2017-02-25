original_image = imread('Images/image2.jpeg');

subplot(441)
filtered_image = denoise(original_image,'box', [3 3]);
imshow(filtered_image, [])
title('Box filter 3x3')

subplot(445)
filtered_image = denoise(original_image,'median', [3 3]);
imshow(filtered_image, [])
title('Median filter 3x3')

subplot(442)
filtered_image = denoise(original_image,'box', [5 5]);
imshow(filtered_image, [])
title('Box filter 5x5')

subplot(446)
filtered_image = denoise(original_image,'median', [5 5]);
imshow(filtered_image, [])
title('Median filter 5x5')

subplot(443)
filtered_image = denoise(original_image,'box', [7 7]);
imshow(filtered_image, [])
title('Box filter 7x7')

subplot(447)
filtered_image = denoise(original_image,'median', [7 7]);
imshow(filtered_image, [])
title('Median filter 7x7')

subplot(444)
filtered_image = denoise(original_image,'box', [9 9]);
imshow(filtered_image, [])
title('Box filter 9x9')

subplot(448)
filtered_image = denoise(original_image,'median', [9 9]);
imshow(filtered_image, [])
title('Median filter 9x9')