function [ G ] = gauss(sigma, kernel_size)
% Create a 1-D gaussian kernel.

% Kernel radius is half the kernel size in this case.
kernel_radius = floor(kernel_size / 2);

% x is symmetric for gaussian
x = linspace(-kernel_radius, kernel_radius, kernel_size);

% Construct gaussian filter
G = exp(-x .^ 2 / (2 * sigma^2));

% Normalize it
G = G / sum(G);

end

