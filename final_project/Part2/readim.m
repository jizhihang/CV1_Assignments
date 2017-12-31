function [data] = readim(filename, resizeTo)
  % Used by imageDatastore
  % Reads one image and resizes it to a given size
  % If the image is grayscale it gets converted to RGB
  data = imread(filename);
  if size(data, 3) == 1
      data = cat(3, data, data, data);
  end
  data = imresize(data, [resizeTo resizeTo]);
  data = im2single(data);
end