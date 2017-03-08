fig_id = figure;

kernel_size = 15;
sigma = 5;
window_size = 20;
threshold = 1;

% Get corners from first image.
[~, r, c] = harris(imread('pingpong/0000.jpeg'), kernel_size, sigma, window_size, threshold);

writer = VideoWriter('person.avi');
writer.FrameRate = 15;
open(writer);

num_files = 52;

% Loop through images creating frame to be fed to video buffer.
for img = 1:num_files
    % Get images from file
    img1 = imread(['pingpong/00' num2str(img-1,'%02d') '.jpeg']);
    img2 = imread(['pingpong/00' num2str(img,'%02d') '.jpeg']);
    
    % Get optical flow arrows
    [vx, vy] = lucas_kanade_points(img1,img2, r, c, kernel_size);
    
    figure(fig_id);
    axis equal
    imshow(rgb2gray(img1))
    hold on;
    
    q = quiver(c,r,vx',vy');
    q.Color = 'red';
    q.LineWidth = 1;
    hold on;
    
    plot(c,r,'r.','MarkerSize',15)
    frame = getframe(gcf);
    writeVideo(writer, frame);
    hold off
    
    
    r = int16(r) + int16(2.9 * vx');
    c = int16(c) + int16(1.5 * vy');
end

close(writer);