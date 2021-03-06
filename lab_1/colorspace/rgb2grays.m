function [output_image] = rgb2grays(input_image)
% converts an RGB into grayscale by using 4 different methods
[R, G, B] = getColorChannels(input_image);

% ligtness method
lightness = (max(input_image, [], 3) + min(input_image, [], 3))/2;

% average method
average = (R + G + B) / 3;

% luminosity method
luminosity = (0.21 * R + 0.72 * G + 0.07 * B);

% built-in MATLAB function 
normal = rgb2gray(input_image);

% Set all grayed images
output_image = cat(3, lightness, average, luminosity, normal);
end

