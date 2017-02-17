function [ albedo, normal, p, q ] = compute_surface_gradient( stack_images, scriptV )
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   stack_image : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   albedo : the surface albedo
%   normal : the surface normal
%   p : measured value of df / dx
%   q : measured value of df / dy

W = size(stack_images, 1);
H = size(stack_images, 2);

% create arrays for 
%   albedo, normal (3 components)
%   p measured value of df/dx, and
%   q measured value of df/dy
albedo = zeros(W, H);
normal = zeros(W, H, 3);
p = zeros(W, H);
q = zeros(W, H);

% TODO: Your code goes here

% Number of images stacked
num_images = size(stack_images,3);

% for each point in the image array
for i=x:W
    for j=y:H
        % stack image values into a vector i
        vect_i = double(reshape(stack_images(x,y,:), [num_images, 1]));
        
        % construct the diagonal matrix scriptI
        scriptI = diag(vect_i);
        
        % solve scriptI * scriptV * g = scriptI * i to obtain g for this point
        [g, ~] = linsolve(scriptI * scriptV, scriptI * i);
        
        % albedo at this point is |g|
        albedo(x,y) = norm(g);
        
        % normal at this point is g / |g|
        normal(x,y,:) = bsxfun(@rdivide, g, norm(g));
        
        %   p at this point is N1 / N3
        %   q at this point is N2 / N3
        p = bsxfun(@rdivide, normal(x,y,1), normal(x,y,3));
        q = bsxfun(@rdivide, normal(x,y,2), normal(x,y,3));
        
    end
end
end

