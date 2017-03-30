function [ ds ] = get_features(img_path, use_dense, sift_type)
% Computes and returns SIFT descriptors for a an image at 
% the specified path.
% Args:
% - img_path: Path of the image we are applying SIFT to.
% - use_dense: If true use vl_dsift, otherwise vl_sift
% - sift_type: Type of SIFT: 'RGB', 'rgb', 'opponent'.

img = imread(img_path); 

switch sift_type
    case 'RGB'
        img = im2single(img);
        ds = color_sift(img, use_dense);
    case 'rgb'
        img = im2single(color_convert(img, 'RGB2rgb'));
        ds = color_sift(img, use_dense);
    case 'opponent'
        img = im2single(color_convert(img, 'RGB2opponent'));
        ds = color_sift(img, use_dense);
    case 'hsv'
        img = im2single(color_convert(img,'RGB2hsv'));
        ds = color_sift(img, use_dense);
    case 'gray'
        img = im2single(img);
        ds = gray_sift(img, use_dense);
    otherwise
        throw(MException('SIFT:TYPE', 'Wrong sift type.'));
end
    
end

function [ds] = color_sift(img, use_dense)
    % If we are using kp, first transform
    % to grayscale, find keypoints on grayscale
    % and then find and concatenate individual
    % descriptors for each color channel.
    if use_dense
        % TODO tuning for these parameters
        step = 16; 
        size = 8;
        % Descriptors on each channel
       [~, descR] = vl_dsift(img(:,:,1),'step',step,'size',size);
       [~, descG] = vl_dsift(img(:,:,2),'step',step,'size',size);
       [~, descB] = vl_dsift(img(:,:,3),'step',step,'size',size);
    else
       % Kp on grayscale
       img = rgb2gray(img);
       [kp, ~] = vl_sift(img);
       
       % Descriptors on each channel
       [~, descR] = vl_sift(img(:,:,1),'frames',kp);
       [~, descG] = vl_sift(img(:,:,2),'frames',kp);
       [~, descB] = vl_sift(img(:,:,3),'frames',kp);
       
    end
    % Stack
    ds = cat(1, cat(1, descR, descG), descB);
end

function [ds] = gray_sift(img, use_dense)
    % TODO tuning for these parameters
    step = 16; 
    size = 8;
    
    if use_dense
        [~, ds] = vl_dsift(img, 'step', step, 'size', size);
    else
        [~, ds] = vl_sift(img);
    end
end


