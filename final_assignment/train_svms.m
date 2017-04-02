function [ svm1, svm2, svm3, svm4 ] = train_svms( data, labels, kernel_type )
% Train num_classes SVMs given the training data and labels.
% - data should be a matrix where all 4 classes have been concatenated
% i.e. 1/4 features from each class.
% - labels should be a matrix with the same number of rows, and 1 column
% - kernel_type, type of kernel to be used when training the SVM.
target1 = double(labels == 1);
target2 = double(labels == 2);
target3 = double(labels == 3);
target4 = double(labels == 4);

svm1 = fitcsvm(data, target1,'Standardize',true,'KernelFunction',kernel_type);
svm2 = fitcsvm(data, target2,'Standardize',true,'KernelFunction',kernel_type);
svm3 = fitcsvm(data, target3,'Standardize',true,'KernelFunction',kernel_type);
svm4 = fitcsvm(data, target4, 'Standardize',true,'KernelFunction',kernel_type);

end

