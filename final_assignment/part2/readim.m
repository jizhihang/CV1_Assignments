function [data] = readim(filename, resizeTo)
  data = imread(filename);
  if size(data, 3) == 1
      data = cat(3, data, data, data);
  end
  data = imresize(data, [resizeTo resizeTo]);
  data = im2single(data);
end