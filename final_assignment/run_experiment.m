function [] = run_experiment(vocab_size, use_dense, sift_type, kernel,...
                             num_vocab, num_train, step_size, block_size)
                             
%%%% Data Files
image_folder = 'Caltech4/ImageData/';
test_files = 'Caltech4/ImageSets/test.txt';
%%%%

%%%%% Feature files
dense = 'kp_';
if use_dense
    dense = 'dense_';
end
feature_folder = 'Caltech4/FeatureData/';
ds_file = strcat(feature_folder, 'ds_vsize-', num2str(vocab_size), '_SIFT-',...
 sift_type,'_',dense,'ntrain-',num2str(num_train),'.mat'); 
centroid_file = strcat(feature_folder, 'centroid_vsize-', num2str(vocab_size), '_SIFT-',...
 sift_type,'_',dense,'ntrain-',num2str(num_train),'.mat');
train_l_file = strcat(feature_folder, 'trlabel_vsize-', num2str(vocab_size), '_SIFT-',...
 sift_type,'_',dense,'ntrain-',num2str(num_train),'.mat');
test_l_file = strcat(feature_folder, 'tslabel_vsize-', num2str(vocab_size), '_SIFT-',...
 sift_type,'_',dense,'ntrain-',num2str(num_train),'.mat');
x_train_file = strcat(feature_folder, 'xtrain_vsize-', num2str(vocab_size), '_SIFT-',...
 sift_type,'_',dense,'ntrain-',num2str(num_train),'.mat');
x_test_file = strcat(feature_folder, 'xtest_vsize-', num2str(vocab_size), '_SIFT-',...
 sift_type,'_',dense,'ntrain-',num2str(num_train), '.mat');
%%%%%

disp('Fetching vocabulary and training files...');
[vocab_files, train_files] = construct_dataset(image_folder, num_vocab, num_train);

disp('Fetching test files..');
test_files = read_list(test_files);

disp('Constructing visual vocabulary..');
if exist(centroid_file, 'file') == 0
    [centroids, stacked_ds] = build_vocab(vocab_files, vocab_size,...
 use_dense, sift_type, step_size, block_size);
    save(centroid_file, 'centroids');
    save(ds_file, 'stacked_ds');
else
    load(centroid_file);
    load(ds_file);
end

disp('Quantizing images..');
if exist(x_train_file, 'file') == 0
    [train_h, train_l] = quantize_images(train_files, centroids, sift_type,...
 use_dense, step_size, block_size);
    save(x_train_file, 'train_h');
    save(train_l_file, 'train_l');
else
    load(x_train_file);
    load(train_l_file);
end

disp('Training SVM classifiers..');
[svm1, svm2, svm3, svm4] = train_svms(train_h,train_l, kernel);

disp('Getting test set features...');
if exist(x_test_file, 'file') == 0
    [test_h, test_l] = quantize_images(test_files, centroids, sift_type, use_dense, step_size, block_size);
    save(x_test_file, 'test_h');
    save(test_l_file, 'test_l');
else
    load(x_test_file);
    load(test_l_file);
end

disp('Classifying and analyzing results...');
[rankings, accuracies, map] = test_svms(test_h, test_l, test_files, svm1, svm2, svm3, svm4);

disp('Exporting results...');
export_results(rankings, accuracies, map, sift_type, dense,...
vocab_size, num_vocab, num_train, test_files, kernel, step_size, block_size);