function visualize(input_image)
  [~,~,d] = size(input_image);
  figure(1);

  for dimension=1:d
      subplot(1,4,dimension)
      imshow(input_image(:,:,dimension), 'InitialMagnification', 800)
  end
  
  if d == 3
      subplot(1,4,4)
      imshow(input_image)
  end
end

