function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb
[R, G, B] = getColorChannels(input_image);
% divide each channel by R + G + B
output_image = bsxfun(@rdivide, input_image, R + G + B);
end

