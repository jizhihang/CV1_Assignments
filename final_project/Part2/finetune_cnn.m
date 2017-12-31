function [net, info, expdir] = finetune_cnn(varargin)

%% Define options
run(fullfile(fileparts(mfilename('fullpath')), ...
  '..', '..', '..', 'matlab', 'vl_setupnn.m')) ;

opts.modelType = 'lenet' ;
opts.extraPreprocessing = false;
[opts, varargin] = vl_argparse(opts, varargin) ;
if contains(opts.modelType, 'alexnet')
    opts.resizeTo = 250;
    opts.inputSize = 227;
else
    opts.resizeTo = 48;
    opts.inputSize = 32;
end

opts.expDir = fullfile('data', ...
  sprintf('cnn_assignment-%s', opts.modelType)) ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = './data/' ;
opts.imdbPath = fullfile(opts.expDir, 'imdb-caltech.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
[opts, varargin] = vl_argparse(opts, varargin) ;
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

opts.train.gpus = [];



%% update model
if contains(opts.modelType, 'alexnet')
    net = update_alexnet(varargin{:});
else
    net = update_model(varargin{:});
end

%% TODO: Implement getCaltechIMDB function below

if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = getCaltechIMDB(opts.extraPreprocessing, opts.resizeTo, opts.inputSize) ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

%%
net.meta.classes.name = imdb.meta.classes(:)' ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

trainfn = @cnn_train ;
[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', find(imdb.images.set == 2)) ;

expdir = opts.expDir;
end
% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y, opts) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

end

function [images, labels] = getSimpleNNBatch(imdb, batch, opts)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end
% Rotate and crop image randomly
if opts.extraPreprocessing && rand > 0.5
    imgs=images;
    images=zeros(opts.inputSize, opts.inputSize, 3, numel(batch));
    for i = 1:size(images,4)
        images(:,:,:,i) = imcrop(imrotate(imgs(:,:,:,i),...
                                             randi(90),...
                                             'bilinear',...
                                             'crop'),...
                                 [4*randi(3) 4*randi(3) opts.inputSize-1 opts.inputSize-1]);
    end
else
    images = imresize(images, [opts.inputSize opts.inputSize]);
end
% Fancy PCA color perturbation
if opts.extraPreprocessing && rand > 0.5
    V = imdb.meta.eigvec;
    D = imdb.meta.eigval;
    perturbation_vec = sum(V.*(D.*randn(3,1)*0.1)', 1);
    perturbation_mat = reshape(repmat(perturbation_vec, opts.inputSize*opts.inputSize, 1),...
                               opts.inputSize, opts.inputSize, 3);
    images = images + perturbation_mat;
end
images=single(images);
end

% -------------------------------------------------------------------------
function imdb = getCaltechIMDB(extraPreprocessing, resizeTo, inputSize)
% -------------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
classes = {'airplanes', 'cars', 'faces', 'motorbikes'};
splits = {'train', 'test'};

%% TODO: Implement your loop here, to create the data structure described in the assignment

% Construct Datastore from all images
imds = imageDatastore(fullfile('../Caltech4/ImageData'),... 
                      'IncludeSubfolders', true, ...
                      'LabelSource', 'foldername', ...
                      'ReadFcn', @(x) readim(x, resizeTo));

data = cell(1, numel(imds));
labels = cell(1, numel(imds));
sets = cell(1, numel(imds));

% Read each image and convert the labels of the form 'class_split'
% to the appropiate class and split index
for i=1:numel(imds.Labels)
    data{i} = read(imds);
    labels{i} = l2idx(classes, char(imds.Labels(i)));
    sets{i} = l2idx(splits, char(imds.Labels(i)));
end

data = single(cat(4, data{:}));
labels = single(cat(2, labels{:}));
sets = single(cat(2, sets{:}));

%%
% subtract mean
dataMean = mean(data(:, :, :, sets == 1), 4);
data = bsxfun(@minus, data, dataMean);
if extraPreprocessing
    dataStd = std(data(:, :, :, sets == 1), 0, 4);
    data = bsxfun(@rdivide, data, dataStd);
    
    % pixels x rgb
    mat = reshape(permute(reshape(data, [], 3, size(data, 4)), [1 3 2]), [], 3);
    [V, D] = eig(cov(mat));
    imdb.meta.eigvec = V;
    imdb.meta.eigval = D;
end

imdb.images.data = data ;

imdb.images.labels = single(labels) ;
imdb.images.set = sets;
imdb.meta.sets = {'train', 'val'} ;
imdb.meta.classes = classes;

perm = randperm(numel(imdb.images.labels));
imdb.images.data = imdb.images.data(:,:,:, perm);
imdb.images.labels = imdb.images.labels(perm);
imdb.images.set = imdb.images.set(perm);

end

function out = l2idx(strlist, el)
    for i=1:length(strlist)
        if contains(el, strlist{i})
            out = i;
            break;
        end
    end
end