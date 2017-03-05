function [vx, vy] = lucas_kanade(im1, im2)
  % Computes optical flow between im1 and im2
  gim1 = sum(im1,3);
  gim2 = sum(im2,3);
  n = 15;
  
  % Apply optical_flow per region
  r = blockproc(cat(3, gim1, gim2),[n n], @(x) optical_flow(x.data));
  % Remove partial block
  r = r(1:end-1, 1:end-2);
  % Odd columns
  vx = r(1:end, 1:2:end);
  % Even columns
  vy = r(1:end, 2:2:end);
  
  % plot
  % TODO: Meshgrid doesn't work for all n
  [x, y] = meshgrid(n/2:n:size(im1,1)-n/2, n/2:n:size(im1,2)-n/2);
  figure;
  imshow(im1);
  hold on;
  quiver(x, y, vx, vy);
end

function v = optical_flow(x)
  % Optical flow for 2 regions
  r1 = x(:,:,1);
  r2 = x(:,:,2);
  
  % TODO: How to do this with the imfilters?
%   [Gx, Gy] = gradient(fspecial('gaussian', 15, 5));
%   Ix = imfilter(r1, Gx, 'same');
%   Iy = imfilter(r1, Gy, 'same');
  [Ix, Iy] = imgradientxy(double(r1));
  
  A = double([Ix(:) Iy(:)]);
  
  b = double(r1 - r2);
  b = b(:);
  
  v = linsolve(A' * A, A' * b);
  v=v';
end