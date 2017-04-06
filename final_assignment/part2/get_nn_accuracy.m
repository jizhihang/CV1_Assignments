function [accuracy] = get_nn_accuracy(net, data)
% Extracted out of train_svm
% Uses test mode and resizes the images correctly
net.layers{end}.type='softmax';
counter = 0;
for i = 1:size(data.images.data, 4)
    
if(data.images.set(i)==2) 
im = imresize(data.images.data(:,:,:,i), [net.meta.inputSize(1) net.meta.inputSize(2)]);
res = vl_simplenn(net, im, [], [], 'Mode', 'test');

[~, estimclass] = max(res(end).x);

if(estimclass == data.images.labels(i))
    counter = counter+1;
end

end

end
accuracy = counter / nnz(data.images.set==2);
end