kernel_size = 15;
sigma = 5;
window_size = 20;
threshold = 1;

% Get corners from first image.
[~, r, c] = harris(imread('pingpong/0000.jpeg'), kernel_size, sigma, window_size, threshold, false);

num_files = 52;

% Loop through images creating frame to be fed to video buffer.
for img = 1:num_files
    % Get images from file
    img1 = imread(['pingpong/00' num2str(img-1,'%02d') '.jpeg']);
    img2 = imread(['pingpong/00' num2str(img,'%02d') '.jpeg']);
    
    % Get optical flow arrows
    [vx, vy] = lucas_kanade_points(img1,img2, r, c, kernel_size);
    
    fig = figure(img);
    axis equal
    imshow(rgb2gray(img1))
    hold on;
    
    q = quiver(c,r,vx',vy');
    q.Color = 'red';
    q.LineWidth = 1;
    hold on;
    
    plot(c,r,'r.','MarkerSize',15)
    file = ['pingpong_frames/' num2str(img) '.png'];
%     set(fig, 'Position', [0 0 1167 875])
    saveas(fig, file);
    pause(0.8);
    close(fig);    
    
    r = int16(r) + int16(2.9 * vx');
    c = int16(c) + int16(1.5 * vy');
end


writer = VideoWriter('pingpong.avi');
writer.FrameRate = 10;
open(writer);

for file_index = 1:num_files
    file = ['pingpong_frames/' num2str(file_index,'%d') '.png'];
    frame = imread(file);
    writeVideo(writer, frame);
end

close(writer);