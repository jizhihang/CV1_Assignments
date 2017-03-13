function [ best_M, best_T, inliers ] = RANSAC( im1, im2, N, P )
  % Transforms `im1` to `im2` using matching points `points`.
  
  [matches, ka, kb] = keypoint_matchings(im1, im2);
  % Get all matches from im1 and im2
  allxy = ka(:, matches(1, :))';
  tallxy = kb(:, matches(2, :))'; % transformedxy
  
  best_num_inliers = 0;
  for i=1:N
      % Sample P matches [num_samples x 2]
      idx = randperm(size(matches,2), P);
      xy = allxy(idx, [1 2]);
      txy = tallxy(idx, [1 2]);
      
      % Construct A and b
      a1=[xy repmat([0 0 1 0], [size(xy,1) 1])];
      a2=[repmat([0 0], [size(xy, 1) 1]) xy repmat([0 1], [size(xy,1) 1])];
      % Interleave a1 and a2
      A = reshape([a1, a2]', 6, [])';
      b = reshape(txy', 1, [])';
      
      x = pinv(A) * b;
      M = reshape(x(1:4), 2, 2)';
      T = x(5:6);
      
      % Transform all matches in new space
      cxy = (M * allxy(:,[1 2])' + T)'; % candidatexy
      
      % Compute distances
      d = sqrt((cxy(:,1) - tallxy(:,1)).^2 + (cxy(:,2) - tallxy(:,2)));
      
      num_inliers = sum(d < 10);
      if num_inliers > best_num_inliers
          best_num_inliers = num_inliers;
          best_M = M;
          best_T = T;
          inliers = allxy(d<10, :);
      end     
  end

end