function [ imOut ] = myHistMatching( input, reference )
  %MYHISTMATCHING Summary of this function goes here
  %
  %   Transforms input s.t. it has a histogram
  %   matching the one of the reference image.
  %
  
  % take the normalized cumsum of input and ref
  nc_in = normalized_cum(input);
  nc_ref = normalized_cum(reference);

  % map the indices in nc_in with the closest matching indices in nc_ref
  map = zeros(256, 1, 'uint8');
  for i = 1:256
      [~, idx] = min(abs(nc_in(i) - nc_ref));
      map(i) = idx;
  end
  
  % apply mapping
  imOut = map(input);
  
  % plots
  plot_and_hist(input, 'input');
  plot_and_hist(reference, 'reference');
  plot_and_hist(imOut, 'output');
end

% compute the normalized cumulative sum of the histogram of in
function nc = normalized_cum(in)
  [hist_counts, ~] = imhist(in);
  nc = cumsum(hist_counts)/sum(hist_counts);
  %nc = cum ./ cum(end);
end

function plot_and_hist(img, name)
  figure;
  subplot(1, 2, 1);
  imshow(img);
  title(sprintf('%s image', upper(name)));
  subplot(1, 2, 2);
  histogram(img);
  title(sprintf('Histogram of the %s image', name));
end