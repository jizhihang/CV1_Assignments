function [ dpdy, dqdx ] = check_integrability( p, q )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   p : measured value of df / dx
%   q : measured value of df / dy
%   dpdy : second derivative dp / dy
%   dqdx : second derviative dq / dx

% TODO: Your code goes here
% approximate derivate by neighbor difference

% This approximation works by neighbor difference
% Comparison could also be replaced with a very small number
% i.e. diff^2 > 0.005

% dpdy = zeros(size(p, 1), size(p, 2));
% dqdx = zeros(size(q, 1), size(q, 2));
% for x=1:size(p,1)-1
%     for y=1:size(p,2)-1
%         diff = (p(x,y) - p(x,y+1)) - (q(x,y) - q(x+1,y));
%         if diff^2 > 0
%             q(x,y) = 0;
%             p(x,y) = 0;
%         end
%         dpdy(x,y) = p(x,y) - p(x,y+1);
%         dqdx(x,y) = q(x,y) - q(x+1,y);
%     end
% end

% The built in 'gradient' seems to give lower errors
[~, dpdy] = gradient(p);
[dqdx, ~] = gradient(q);
end

