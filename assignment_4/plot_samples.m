function [] = plot_samples(p1, p2, im1, im2)
    p2(2, :) = p2(2, :) + size(im1, 1);

    imshow(cat(1, im1, im2));
    hold on;
    vl_plotframe(p1);
    vl_plotframe(p2);
    for i = 1:size(p1,2)
        l = line([p1(1, i); p2(1, i)], [p1(2,i); p2(2,i)]);
        set(l,'linewidth', 1, 'color', 'b');
    end
end