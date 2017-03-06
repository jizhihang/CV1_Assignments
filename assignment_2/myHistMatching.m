function [ imOut ] = myHistMatching( input, reference )
  %MYHISTMATCHING Summary of this function goes here
  %
  %   Transforms input s.t. it has a histogram
  %   matching the one of the reference image.
  %
  
  % take the normalized cumsum of input and ref
  nc_in = normalized_cum(input);
  nc_ref = normalized_cum(reference);

  % Based on http://fourier.eng.hmc.edu/e161/lectures/contrast_transform/node3.html
  % map the indices in nc_in with the index of the closest value in nc_ref
  in2ref = zeros(256, 1, 'uint8');
  for i = 1:256
      min = inf;
      idx = 1;
      % Find the closest matching value in nc_ref for a given nc_in(i)
      for j = 1:256
          candidate = abs(nc_in(i) - nc_ref(j));
          if candidate < min
              min = candidate;
              idx = j;
          end
      end 
      in2ref(i) = idx;
  end
  
  % apply mapping
  imOut = in2ref(input);
  
  % plots
  plot_and_hist(input, 'input');
  plot_and_hist(reference, 'reference');
  plot_and_hist(imOut, 'output');
end

% compute the normalized cumulative sum of the histogram of in
function nc = normalized_cum(in)
  [hist_counts, ~] = imhist(in);
  nc = cumsum(hist_counts)/sum(hist_counts);
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