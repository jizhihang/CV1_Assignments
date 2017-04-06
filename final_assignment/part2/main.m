%% main function 
type = 'lenet';
if strcmp(type, 'lenet')
    batchSize = 50;
    numEpochs = 40;
    % Can preload here if "model" matches existing folder in data
    model = sprintf('batchSize-%d-numEpochs-%d', batchSize, numEpochs);
    [net, info, expdir] = finetune_cnn('modelType', model,...
                                       'batchSize', batchSize,...
                                       'numEpochs', numEpochs);
    nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
else
    batchSize = 64;
    numEpochs = 120;
    [net, info, expdir] = finetune_cnn('modelType', sprintf('alexnet-batchSize-%d-numEpochs-%d-extraPreprocessing', batchSize, numEpochs),...
    'batchSize', batchSize,...
    'numEpochs', numEpochs, 'extraPreprocessing', true);
    nets.pre_trained = vl_simplenn_tidy(load(fullfile('data', 'imagenet-caffe-alex.mat')));
    nets.pre_trained.meta.inputSize=[227 227];
end

%% extract features and train svm

nets.fine_tuned = net;
data = load(fullfile(expdir, 'imdb-caltech.mat'));


%%
train_svm(nets, data);

%% Visualize
visualize_nets(nets, data);