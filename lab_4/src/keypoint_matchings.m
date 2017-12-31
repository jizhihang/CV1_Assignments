function [matches, ka, kb] = keypoint_matchings(im1, im2)
  % Computes keypoint matchings between im1 and im2
  
  % Our example images are greyscale so we don't need to convert
  im1 = single(im1);
  im2 = single(im2);
  
  % Keypoints and descriptors
  [ka, da] = vl_sift(im1);
  [kb, db] = vl_sift(im2);
  
  % Matches
  [matches, ~] = vl_ubcmatch(da, db, 3);
end