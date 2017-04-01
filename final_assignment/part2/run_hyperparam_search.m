batchSizes = {50, 100};
numEpochs = {40, 80, 120};

rowNames = {};
trainErrs = [];
valErrs = [];
for i = 1:numel(batchSizes)
    for j = 1:numel(numEpochs)
        bs = batchSizes{i};
        ne = numEpochs{j};
        [net, info, expdir] = finetune_cnn('modelType', sprintf('batchSize-%d-numEpochs-%d', bs, ne),...
                                           'batchSize', bs,...
                                           'numEpochs', ne);
        %errors{j + (i-1)*numel(numEpochs)} = sprintf('batchSize %d numEpochs %d train_err %f val_err %f',...
                %bs, ne, mean([info.train.top1err]), mean([info.val.top1err]));
        rowNames{j+(i-1)*numel(numEpochs)} = sprintf('batchSize %d numEpochs %d', bs, ne);
        trainErrs = [trainErrs; mean([info.train.top1err])];
        valErrs = [valErrs; mean([info.val.top1err])];
    end
end
table(trainErrs, valErrs, 'RowNames', [rowNames])