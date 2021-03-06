function [ imOut ] = gaussConv(image, sigma_x, sigma_y, kernel_size)
% gaussConv - Apply 1D gaussian filter convolution
% across both dimensions.
x_filter = gauss(sigma_x, kernel_size);
y_filter = gauss(sigma_y, kernel_size);

imOut = uint8(floor(conv2(x_filter, y_filter, image, 'same')));
end

