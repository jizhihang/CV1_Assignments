function [] = visualize_nets(nets, data)

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
features = cell2mat(arrayfun(@(idx) get_features(net, data.images.data(:,:,:,idx)),...
                             test_set_indices, 'UniformOutput', false));
labels = data.images.labels(test_set_indices);
end

function f = get_features(net, datapoint)
    res = vl_simplenn(net, datapoint);
    f = squeeze(res(end-3).x);
end