% Files
train_files = 'Caltech4/ImageSets/train.txt';
test_files = 'Caltech4/ImageSets/test.txt';
%%%%

% Hyperparams
vocab_size = 400; % (800, 1600, 2000 and 4000)
use_dense = false; % (true, false)
sift_type = 'RGB'; % ('RGB','rgb','opponent','gray','hsv')
num_train = 10; % (10 for test, 1000, -1 for all)

% Read all training files
train_list = read_list(train_files);

% Number of files to train on
train_idx = randperm(num_train);
train_list = train_list(train_idx);

centroids = build_vocab(train_list, vocab_size, use_dense, sift_type);