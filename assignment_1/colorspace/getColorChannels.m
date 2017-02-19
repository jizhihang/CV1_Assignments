function [R, G, B] = getColorChannels(input_image)
% helper function that seperates an image into its color channels
% color channel is on 3rd dimension, simply slice for 3 channels
R = input_image(:,:,1);
G = input_image(:,:,2);
B = input_image(:,:,3);
end

