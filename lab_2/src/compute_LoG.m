function imOut = compute_LoG(image, LoG_type)
  % Comptutes LoG
  % LoG_type: can be 1, 2, 3
  %     1: Smooth with Gaussian, then take Laplacian
  %     2: Convolve directly with LoG
  %     3: Difference between two Gaussians
  
  switch LoG_type
      case 1
          smoothened = gaussConv(image, 1, 1, 5);
          op = fspecial('laplacian');
          imOut = imfilter(smoothened, op);
      case 2
          op = fspecial('log');
          imOut = imfilter(image, op);
      case 3
          sigma2 = 1;
          sigma1 = sigma2*1.6;
          imOut = gaussConv(image, sigma1, sigma1, 5) - gaussConv(image, sigma2, sigma2, 5);
  end
end