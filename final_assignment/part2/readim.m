function [data] = readim(filename)
  data = imread(filename);
  if size(data, 3) == 1
      data = cat(3, data, data, data);
  end
  data = imresize(data, [32 32]);
  data = im2single(data);
end