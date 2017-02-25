function imOut = compute_LoG(image, LoG_type)
  % Comptutes LoG
  % LoG_type: can be 1, 2, 3
  %     1: Smooth with Gaussian, then take Laplacian
  %     2: Convolve directly with LoG
  %     3: Difference between two Gaussians
  
  switch LoG_type
      case 1
          smoothened = gaussConv(image, 1, 1, 3);
          % TODO: should we do this inside gaussConv?
          smoothened = uint8(floor(smoothened));
          op = fspecial('laplacian');
          imOut = imfilter(smoothened, op);
      case 2
          op = fspecial('log');
          imOut = imfilter(image, op);
      case 3
          % TODO: same as above, if we don't floor and uint8 imshow acts
          % weirdly
          imOut = uint8(floor(gaussConv(image, 0.5, 0.5, 3) - gaussConv(image, 5, 5, 3)));
  end
end