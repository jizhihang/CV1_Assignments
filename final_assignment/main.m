% Files
image_folder = 'Caltech4/ImageData/';
test_files = 'Caltech4/ImageSets/test.txt';
%%%%

%%%%% Hyperparams
vocab_size = 400; % (800, 1600, 2000 and 4000)
use_dense = false; % (true, false)
sift_type = 'RGB'; % ('RGB','rgb','opponent','gray','hsv')
kernel = 'RBF';
num_vocab = 30; % number of images from each class used for vocab
num_train = 30; % number of images used from each class for training svm
%%%%%

disp('Fetching vocabulary and training files...');
[vocab_files, train_files] = construct_dataset(image_folder, num_vocab, num_train);

disp('Fetching test files..');
test_files = read_list(test_files);

disp('Constructing visual vocabulary..');
[centroids, ~] = build_vocab(vocab_files, vocab_size, use_dense, sift_type);

disp('Quantizing images..');
[train_h, train_l] = quantize_images(train_files, centroids, sift_type, use_dense);

disp('Training SVM classifiers..');
[svm1, svm2, svm3, svm4] = train_svms(train_h,train_l, kernel);

disp('Getting test set features...');
[test_h, test_l] = quantize_images(test_files, centroids, sift_type, use_dense);

disp('Classifying and analyzing results...');
[rankings, accuracies, map] = test_svms(test_h, test_l, test_files, svm1, svm2, svm3, svm4);

disp(accuracies);
disp(map);