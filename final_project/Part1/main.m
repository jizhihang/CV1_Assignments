%%%%% Hyperparams
vocab_sizes = [400, 800]; % (400, 800, 1600, 2000 and 4000)
use_denses = [true, false]; % (true, false)
sift_types = {'RGB', 'hsv', 'opponent', 'gray', 'rgb'}; % ('RGB','rgb','opponent','gray','hsv')
kernels = {'linear', 'RBF'};
num_vocab = 100; % vocab fraction
num_train = 55; % number of images used from each class for training svm
step_size = 10;
block_size = 5;
%%%%%

for i=1:length(vocab_sizes)
    vocab_size = vocab_sizes(i);
    for j = 1:length(use_denses)
        use_dense = use_denses(j);
        for k = 1:length(sift_types)
            sift_type = sift_types{k};
            for l = 1:length(kernels)
                kernel = kernels{l};
                run_experiment(vocab_size, use_dense, sift_type, kernel,...
                               num_vocab, num_train, step_size, block_size)
            end
        end
    end
end