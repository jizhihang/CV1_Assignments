function [H, r, c] = harris(img, kernel_size, sigma, n, threshold)
 % size and sigma are the kernel size and sigma for the gaussian kernel
 % n is the window size for the neighbour window
 % threshold is a user defined value for a corner point
 
 % returns the H matrix
 % along with the row and columns of the corners
 grayscale_image = double(rgb2gray(img));

 % By applying a Gaussian filter, convolve at each i,j point
 % Also compute the gaussian derivative.
 G = fspecial('gaussian', kernel_size, sigma);
 [Gx, Gy] = gradient(G);
 
 % Find derivatives by convolving with image
 Ix = imfilter(grayscale_image, Gx, 'same');
 Iy = imfilter(grayscale_image, Gy, 'same');
 
 % Construct A,B,C
 A = imfilter(Ix .* Ix, G, 'same');
 B = imfilter(Ix .* Iy, G, 'same');
 C = imfilter(Iy .* Iy, G, 'same');
 
 % Construct the H matrix.
 H = (A.*C - B.^2) - 0.04 .* (A + C) .^ 2;

 % Sliding window to determine max in each neighbourhood
 maxH = imdilate(H, ones(n*2+1));
 
 % Equivalent but slower
 % maxH = nlfilter(H, [n*2+1 n*2+1], @(x) max(x(:)));

 % Value is good if it's the maximum in that neighbourhood and it's above
 % the threshold
 corners = (H == maxH) & (H > threshold);
 
 % For better illustration, we also remove those
 % found in the corners of the image.
 corners(end - n:end, end - n:end) = 0;
 corners(1:n, end - n:end) = 0;
 corners(1:n, 1:n) = 0;
 corners(end - n:end, 1:n) = 0;
 
 % Return row and column indices of corners
 % Essentially looking for non-zero values.
 [r, c] = find(corners);
 
 % debug plots
%  figure;
%  subplot(4,1,1),imshow(H);
%  subplot(4,1,2),imshow(H==maxH);
%  subplot(4,1,3),imshow(H>threshold);
%  subplot(4,1,4),imshow(H==maxH&H>threshold);

 figure;
 subplot(131), imshow(100 * Ix); title('Derivatives in X direction')
 subplot(132), imshow(100 * Iy); title('Derivatives in Y direction')
 subplot(133), imshow(img); hold on; plot(c,r, 'go'); title('Corners')
end
