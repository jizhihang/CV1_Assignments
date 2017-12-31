function [im_magnitude ,im_direction] = compute_gradient(image)
  % Compute gradient of a image
  image = im2double(image);
  % Sobel kernel
  gy = fspecial('Sobel');
  gx = gy';
  
  % Apply filters
  grad_x = imfilter(image, gx);
  grad_y = imfilter(image, gy);
  
  % Compute magnitude and direction
  im_magnitude = sqrt(grad_x.^2+grad_y.^2);
  im_direction = atan2(grad_y,grad_x);
  
  % plots
  colormap(bone);
  subplot(3, 2, 1), imagesc(grad_x), colorbar, title('Gradient X');
  subplot(3, 2, 2), imagesc(grad_y), colorbar, title('Gradient Y');
  subplot(3, 2, 3), imagesc(im_magnitude),colorbar, title('Gradient Magnitude');
  subplot(3, 2, 4), imagesc(im_direction), colorbar, title('Gradient Direction');
  subplot(3, 2, 5), imagesc((im_magnitude > 0.5).*im_direction), colorbar, title('Gradient Direction for places where the magnitude is > 0.5');

end