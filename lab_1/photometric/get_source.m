function [ scriptV ] = get_source(scale_factor)
%GET_SOURCE compute illumination source property 
%   scale_factor : arbitrary 

if nargin == 0
    scale_factor = 1;
end
scriptV = 0;

% TODO: define arbitrary direction to V
% fontal, left-above, right-above, right-below, left-below
V = [[ 0  0 -1];
     [ 1 -1 -1];
     [-1 -1 -1];
     [ 1  1 -1];
     [-1  1 -1]];


% TODO: normalize V into scriptV
N = sqrt(sum(abs(V).^2, 2));
scriptV = bsxfun(@rdivide, V, N);


% scale up to scale factor before return
scriptV = scale_factor * scriptV;

end

