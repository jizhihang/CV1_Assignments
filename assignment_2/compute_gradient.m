function [im_magnitude ,im_direction] = compute_gradient(image)
  % Compute gradient of a image
  image = im2double(image);
  % Sobel kernel
  gx = [1; 2; 1] * [-1 0 1];
  gy = -gx';
  
  % Apply filters
  grad_x = conv2(gx, image, 'full');
  grad_y = conv2(gy, image, 'full');
  
  % Compute magnitude and direction
  im_magnitude = sqrt(grad_x.^2+grad_y.^2);
  im_direction = atan(grad_y./grad_x);
  
  % plots
  % TODO: If we use some main to plot, we can't plot grad_x and grad_y
  subplot(2, 2, 1), imshow(grad_x), title('Gradient X');
  subplot(2, 2, 2), imshow(grad_y), title('Gradient Y');
  subplot(2, 2, 3), imshow(im_magnitude), title('Gradient Magnitude');
  % TODO: How do we plot direction for it to look decent?
  subplot(2, 2, 4), imshow(im_direction), title('Gradient Direction');

end