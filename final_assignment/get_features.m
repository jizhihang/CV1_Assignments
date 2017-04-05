function [ ds ] = get_features(img_path, use_dense, sift_type, step, block_size)
% Computes and returns SIFT descriptors for a an image at 
% the specified path.
% Args:
% - img_path: Path of the image we are applying SIFT to.
% - use_dense: If true use vl_dsift, otherwise vl_sift
% - sift_type: Type of SIFT: 'RGB', 'rgb', 'opponent', 'gray', 'hsv'.

img = imread(img_path);

% Preprocessing
if strcmp(sift_type, 'gray') && size(img,3) > 2
    % graySIFT but input image has normal # of color ch.
    img = img2gray(img);
elseif ~strcmp(sift_type, 'gray') && size(img,3) < 3
    % colorSIFT but input image is grayscale.
    im = img;
    img(:,:,1) = im;
    img(:,:,2) = im;
    img(:,:,3) = im;
end
    

switch sift_type
    case 'RGB'
        img = im2single(img);
        ds = color_sift(img, use_dense, step, block_size);
    case 'nrgb'
        img = im2single(color_convert(img, 'RGB2rgb'));
        ds = color_sift(img, use_dense, step, block_size);
    case 'opponent'
        img = im2single(color_convert(img, 'RGB2opponent'));
        ds = color_sift(img, use_dense, step, block_size);
    case 'hsv'
        img = im2single(color_convert(img,'RGB2hsv'));
        ds = color_sift(img, use_dense, step, block_size);
    case 'gray'
        img = im2single(img);
        ds = gray_sift(img, use_dense, step, block_size);
    otherwise
        throw(MException('SIFT:TYPE', 'Wrong sift type.'));
end
    
end

function [ds] = color_sift(img, use_dense, step, block_size)
    % If we are using kp, first transform
    % to grayscale, find keypoints on grayscale
    % and then find and concatenate individual
    % descriptors for each color channel.
    if use_dense
        % Descriptors on each channel
       [~, descR] = vl_dsift(img(:,:,1),'step',step,'size',block_size);
       [~, descG] = vl_dsift(img(:,:,2),'step',step,'size',block_size);
       [~, descB] = vl_dsift(img(:,:,3),'step',step,'size',block_size);
    else
       % Kp on grayscale
       img_gray = rgb2gray(img);
       [kp, ~] = vl_sift(img_gray);
       
       % Descriptors on each channel
       [~, descR] = vl_sift(img(:,:,1),'frames',kp);
       [~, descG] = vl_sift(img(:,:,2),'frames',kp);
       [~, descB] = vl_sift(img(:,:,3),'frames',kp);
    end
    % Stack
    ds = cat(1, cat(1, descR, descG), descB);
end

function [ds] = gray_sift(img, use_dense, step, block_size)    
    if use_dense
        [~, ds] = vl_dsift(img, 'step', step, 'size', block_size);
    else
        [~, ds] = vl_sift(img);
    end
end


