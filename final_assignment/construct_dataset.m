function [ vocab_files, train_files ] = construct_dataset(folder, num_vocab, num_train )
% Returns necessary images to construct visual vocabulary and 
% training files for the SVM.
% folder - Folder containing 'classname_train' folders with images.
% num_vocab - the nr of images to be used from each class to build vocab
% num_train - number of training images from each class for SVM.

categs = {'airplanes', 'cars', 'faces', 'motorbikes'};
vocab_files = {};
train_files = {};

for i=1:length(categs)
    categ_file = char(strcat(folder,categs(i),'_train','/'));
    
    % Get number of training images in file
    d = dir([categ_file, '*.jpg']);
    num_images = length(d);
    
    if strcmp(num_vocab, 'half') || strcmp(num_train, 'half')
            half = int16(num_images / 2);
            num_v = half;
            num_t = half;
            limit = num_images;            
    elseif (num_vocab + num_train) > num_images
        throw(MException('DATASET', 'Not enough images, change num_train.'));
    else
        num_v = num_vocab;
        num_t = num_train;
        limit = (num_v + num_t);   
    end

    for j=1:limit
        % Don't use same images for training and vocabulary construction.        
        if j > num_v
            train_file = strcat(categ_file,'img',num2str(j, '%.3d'), '.jpg');
            train_files{end+1,1} = train_file;
        else
            vocab_file = strcat(categ_file,'img',num2str(j,'%.3d'),'.jpg');
            vocab_files{end+1,1} = vocab_file;
        end
    end
end
end

