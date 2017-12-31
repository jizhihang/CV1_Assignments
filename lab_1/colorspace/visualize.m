function visualize(input_image, colorspace)
  d = size(input_image, 3);
  % handle greyscale images separately
  if d == 4
      visualize_greyscale(input_image, d)
  else
      visualize_color(input_image, d, colorspace)
  end
end

function visualize_greyscale(input_image, d)
    % plot each dimension in greyscale to get the 4 different types
    for dimension=1:d
        img = input_image(:, :, dimension);
        subplot(2, 2, dimension), subimage(img), title(sprintf('%s', get_title(dimension,d)));
    end
end

function visualize_color(input_image, d, colorspace)
  % plot final image in the middle
  subplot(3, 3, 2), subimage(input_image), title('Full image');
  for dimension=1:d
      % plot greyscale channels on the 2nd row
      img = input_image(:, :, dimension);
      subplot(3, 3, dimension+3), subimage(img), title(sprintf('Greyscale %s', get_title(dimension,d)));
      
      % if plotting RGB, plot colored RGB on the 3rd row
      if strcmp(colorspace, 'rgb') || strcmp(colorspace, 'opponent')
          chan = uint8(zeros(size(input_image)));
          chan(:, :, dimension) = input_image(:, :, dimension) .* 255;
          subplot(3, 3, dimension+6), subimage(chan), title(sprintf('%s', get_title(dimension,d)));
      end
  end
end

% dimension to string converter
function t = get_title(d, max_dimensions)
  if max_dimensions == 3
      switch d
          case 1
              t = 'Channel 1';
          case 2
              t = 'Channel 2';
          case 3
              t = 'Channel 3';
      end
  else
      switch d
          case 1
              t = 'Lightness';
          case 2
              t = 'Average';
          case 3
              t = 'Luminosity';
          case 4
              t = 'Matlab';
      end
  end 
end