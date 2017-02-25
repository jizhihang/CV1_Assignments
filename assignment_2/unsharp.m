function imOut = unsharp (image , sigma , kernel_size , k)
  % Unsharp masking

  % Own build of the gaussian smoothing
  smoothened = gaussConv(image, sigma, sigma, kernel_size);
  image = double(image);
  high_pass = image - smoothened;
  high_pass = high_pass .* k;

  imOut = image + high_pass;
  
  subplot(2,2,1), imshow(image, []), title('Original image');
  subplot(2,2,2), imshow(smoothened, []), title('Smoothened image');
  subplot(2,2,3), imshow(high_pass, []), title('High pass image');
  subplot(2,2,4), imshow(imOut, []), title('Final image');
  % TODO: images end up having a bit of grey from
  % the high pass filter
end