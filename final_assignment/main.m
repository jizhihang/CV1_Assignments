% Files
image_folder = 'Caltech4/ImageData/';
%%%%

%%%%% Hyperparams
vocab_size = 400; % (800, 1600, 2000 and 4000)
use_dense = false; % (true, false)
sift_type = 'RGB'; % ('RGB','rgb','opponent','gray','hsv')
kernel = 'RBF';
num_vocab = 10; % number of images from each class used for vocab
num_train = 10; % number of images used from each class for training svm
%%%%%

[vocab_files, train_files] = construct_dataset(image_folder, num_vocab, num_train);
[centroids, ~] = build_vocab(vocab_files, vocab_size, use_dense, sift_type);
[h, l] = quantize_images(train_files, centroids, sift_type, use_dense);
[svm1, svm2, svm3, svm4] = train_svms(h,l, kernel);

