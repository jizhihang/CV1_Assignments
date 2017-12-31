original_image = imread('Images/image2.jpeg');

subplot(241)
filtered_image = denoise(original_image,'box', [3 3]);
imshow(filtered_image, [])
title('Box filter 3x3')

subplot(245)
filtered_image = denoise(original_image,'median', [3 3]);
imshow(filtered_image, [])
title('Median filter 3x3')

subplot(242)
filtered_image = denoise(original_image,'box', [5 5]);
imshow(filtered_image, [])
title('Box filter 5x5')

subplot(246)
filtered_image = denoise(original_image,'median', [5 5]);
imshow(filtered_image, [])
title('Median filter 5x5')

subplot(243)
filtered_image = denoise(original_image,'box', [7 7]);
imshow(filtered_image, [])
title('Box filter 7x7')

subplot(247)
filtered_image = denoise(original_image,'median', [7 7]);
imshow(filtered_image, [])
title('Median filter 7x7')

subplot(244)
filtered_image = denoise(original_image,'box', [9 9]);
imshow(filtered_image, [])
title('Box filter 9x9')

subplot(248)
imshow(original_image, [])
title('Original image')