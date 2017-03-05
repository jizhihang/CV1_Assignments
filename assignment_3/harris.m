function [H, r, c] = harris(img, kernel_size, sigma, n, threshold)
 % size and sigma are the kernel size and sigma for the gaussian kernel
 % n is the window size for the neighbour window
 % threshold is a user defined value for a corner point
 
 % returns the H matrix
 % along with the row and columns of the corners
 
 grayscale_image = double(rgb2gray(img));

 G = fspecial('gaussian', kernel_size, sigma);
 [Gx, Gy] = gradient(G);
 Ix = imfilter(grayscale_image, Gx, 'same');
 Iy = imfilter(grayscale_image, Gy, 'same');
 
 A = imfilter(Ix .* Ix, G, 'same');
 B = imfilter(Ix .* Iy, G, 'same');
 C = imfilter(Iy .* Iy, G, 'same');
 
 H = (A.*C - B.^2) - 0.04 .* (A + C) .^ 2;

 % Sliding window to determine max in each neighbourhood
 maxH = imdilate(H, ones(n*2+1));
 % Equivalent but slower
 % maxH = nlfilter(H, [n*2+1 n*2+1], @(x) max(x(:)));

 % Value is good if it's the maximum in that neighbourhood and it's above
 % the threshold
 corners = (H == maxH) & (H > threshold);
 
 % Return row and column indices of corners
 [r, c] = find(corners);
 
 % debug plots
%  figure;
%  subplot(4,1,1),imshow(H);
%  subplot(4,1,2),imshow(H==maxH);
%  subplot(4,1,3),imshow(H>threshold);
%  subplot(4,1,4),imshow(H==maxH&H>threshold);

 figure;
 subplot(131), imshow(Ix);
 subplot(132), imshow(Iy);
 subplot(133), imshow(img); hold on; plot(c,r, 'go');
end
