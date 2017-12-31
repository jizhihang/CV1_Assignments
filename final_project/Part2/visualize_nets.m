function [] = visualize_nets(nets, data)

% For all nets, can be more than the default 2
names = fieldnames(nets);
for i=1:numel(names)
    net = nets.(names{i});
    [features, labels] = get_features_labels(net, data);
    figure();
    res = tsne(features', labels');
    f=figure();
    gscatter(res(:, 1), res(:, 2), labels');
    title(strrep(names{i}, '_', ' '));
    saveas(f, sprintf('tsne_%s.png', names{i}));
end

end

function [features, labels] = get_features_labels(net, data)

% replace loss with the classification as we will extract features
net.layers{end}.type = 'softmax';

test_set_indices = find(data.images.set==2);
% Get a set of features for every datapoint
features = cell2mat(arrayfun(@(idx) get_features(net, data.images.data(:,:,:,idx)),...
                             test_set_indices, 'UniformOutput', false));
labels = data.images.labels(test_set_indices);
end

function f = get_features(net, datapoint)
    % Features for one datapoint
    im = imresize(datapoint, [net.meta.inputSize(1) net.meta.inputSize(2)]);
    res = vl_simplenn(net, im, [], [], 'Mode', 'test');
    f = squeeze(res(end-3).x);
end