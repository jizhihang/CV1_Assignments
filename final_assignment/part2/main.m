%% main function 


%% fine-tune cnn

%[net, info, expdir] = finetune_cnn();

% Best hyperparams
batchSize = 50;
numEpochs = 120;
[net, info, expdir] = finetune_cnn('modelType', sprintf('batchSize-%d-numEpochs-%d', batchSize, numEpochs),...
                                   'batchSize', batchSize,...
                                   'numEpochs', numEpochs);
save('net.mat', 'net');
%% extract features and train svm

% TODO: We could just use net here instead of saving to/from file.
% finetune_cnn returns the latest net
nets.fine_tuned = load(fullfile('net.mat')); nets.fine_tuned = nets.fine_tuned.net;
nets.pre_trained = load(fullfile('data', 'pre_trained_model.mat')); nets.pre_trained = nets.pre_trained.net; 
data = load(fullfile(expdir, 'imdb-caltech.mat'));


%%
train_svm(nets, data);

%% Visualize
visualize_nets(nets, data);