% Chance this line to record either ping pong or person with toy video


kernel_size = 17;
sigma = 3;
window_size = 19;
threshold = 200;

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
    saveas(fig, file);
    pause(0.8);
    close(fig);    
    
    if mod(img, 5) == 0
        [~, r, c] = harris(imread(['pingpong/00' num2str(img,'%02d') '.jpeg']), kernel_size, sigma, window_size, threshold, false);
    end
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