function [ imOut ] = denoise( image, kernel_type, kernel_size )
% Denoise by appling box/median filter
% kernel_type is a string which can be either
% 'box' or 'median'
if not(strcmp(kernel_type,'box')) && not(strcmp(kernel_type, 'median'))
   error('Kernel type has to be either box (mean) or median.') 
end

% Get image and kernel sizes
[rows, cols] = size(image);
[kernel_rows, kernel_cols] = size(kernel_size);

% Get size of kernel radius in each direction
% i.e. starting from a center point x, how large is
% the kernel in each direction.
krow_radius = floor(kernel_rows/2);
kcol_radius = floor(kernel_cols/2);

% Pad the image accordingly, so as to preserve the size.
padded_image = paddaray(image, [krow_radius, kcol_radius]);

% New image to be constructed
imOut = zeros([rows, cols]);

% Loop starting from the first position in the image
% And construct submatrixes of kernel size to compute
% either mean filter or median filter.
for r=krow_radius:(rows - krow_radius)
    for c=kcol_radius:(cols - kcol_radius)
        % Construct submatrix
        m = padded_image(r-krow_radius:r+krow_radius, c-kcol_radius:c+kcol_radius);
        
        % Compute mean or median depending on kernel type
        if strcmp(kernel_type,'box')
            imOut(r,c) = mean(m(:));
        else
            imOut(r,c) = median(m(:));
        end
    end
end

end

