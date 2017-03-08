function [vx, vy] = lucas_kanade_points(img1, img2, corner_r, corner_c, window_size)

% Convert to gray scale
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

% Initialize vx, vy
% Cannot prealocate exact size as we need to account for
% corners with windows out of bounds.
vx = [];
vy = [];

% Construct gradients
[Ix, Iy] = imgradientxy(img1);
It = double(img2) - double(img1);

% Get image dimensions
width = size(img1, 1);
height = size(img2, 2);

for corner_i = 1:size(corner_c,1)
    % If we apply a window here, we need make sure we are not
    % outside the bounds of the image. i.e. subtract from the point (r,c)
    % centered here, half the window size and make sure it's > 0 and
    % less than the maximum size of the image on both dimensions.
    box_x = int8(corner_r(corner_i) - floor(window_size)/2 + 1);
    box_y = int8(corner_c(corner_i) - floor(window_size)/2 + 1);
    
    if (box_x + window_size) > width || (box_y + window_size) > height || box_x <= 0 || box_y <= 0
        vx = [vx 0];
        vy = [vy 0];
        continue
    end
    
    % If window centered here is not out of bounds, continue.
    % First construct windows
    window_x = Ix(box_x:(box_x + window_size), box_y:(box_y + window_size));
    window_y = Iy(box_x:(box_x + window_size), box_y:(box_y + window_size));
    window_t = It(box_x:(box_x + window_size), box_y:(box_y + window_size));
    
    % Construct A,b matrices
    A = double([window_x(:), window_y(:)]);
    b = -window_t(:);
    
    % Solve linear equation and obtain solution
    U = pinv(A) * b;
    vx = [vx U(1)];
    vy = [vy U(2)];
end