function [ imOut ] = denoise( image, kernel_type, kernel_size )
% Denoise by appling box/median filter
% :image is the original image to which we are applying th filters
% :kernel_type is a string which can be either
% 'box' or 'median'
% :kernel_size is array of [kernel_row_size, kernel_col_size]
if not(strcmp(kernel_type,'box')) && not(strcmp(kernel_type, 'median'))
   error('Kernel type has to be either box (mean) or median.') 
end

% Get image and kernel sizes
kernel_rows = kernel_size(1);
kernel_cols = kernel_size(2);
rows = size(image,1);
cols = size(image,2);

% New image to be constructed
imOut = zeros([rows, cols], 'uint8');

% Get size of kernel radius in each direction
% i.e. starting from a center point x, how large is
% the kernel in each direction.
krow_radius = floor(kernel_rows/2);
kcol_radius = floor(kernel_cols/2);

% Pad the image accordingly, so as to preserve the size.
padded_image = padarray(image, [krow_radius, kcol_radius]);

% New rows and cols
rows = size(padded_image,1);
cols = size(padded_image,2);

% Loop starting from the first position in the image
% And construct submatrixes of kernel size to compute
% either mean filter or median filter.
for r=krow_radius+1:(rows - krow_radius)
    for c=kcol_radius+1:(cols - kcol_radius)
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

