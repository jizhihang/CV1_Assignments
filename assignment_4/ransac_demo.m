% im1 to im2
[M, T, ~] = RANSAC(im1, im2, 5, 3);

[matches, ka, kb] = keypoint_matchings(im1, im2);
allxy = ka(:, matches(1, :))';
% Transform allxy into the new space using the best parameters
callxy = [(M * allxy(:,[1 2])' + T)' allxy(:, [3 4])];

% Plot only some sparse samples so it becomes relatively understandable
allxy = allxy(1:20:200, :);
callxy = callxy(1:20:200, :);
plot_samples(allxy', callxy', im1, im2);

figure;

% im2 to im1
[M, T, ~] = RANSAC(im2, im1, 5, 3);

allxy = kb(:, matches(2, :))';
% Transform allxy into the new space using the best parameters
callxy = [(M * allxy(:,[1 2])' + T)' allxy(:, [3 4])];

% Plot only some sparse samples so it becomes relatively understandable
allxy = allxy(1:20:200, :);
callxy = callxy(1:20:200, :);
plot_samples(allxy', callxy', im2, im1);