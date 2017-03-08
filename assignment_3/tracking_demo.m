% Chance this line to record either ping pong or person with toy video
rec_type = 'person_toy'; % options are 'pingpong' or 'person_toy'

if strcmp(rec_type, 'pingpong')
kernel_size = 17;
sigma = 3;
window_size = 19;
threshold = 200;
first_img = imread('pingpong/0000.jpeg');
num_files = 52;
saving_folder = 'pingpong_frames/';
video_name = 'pingpong.avi';
elseif strcmp(rec_type, 'person_toy')
kernel_size = 17;
sigma = 3;
window_size = 19;
threshold = 200;
first_img = imread('person_toy/00000001.jpg');
num_files = 103;
saving_folder = 'person_toy_frames/';
video_name = 'person_toy.avi';
end

% Get corners from first image.
[~, r, c] = harris(first_img, kernel_size, sigma, window_size, threshold, false);

% Loop through images creating frame to be fed to video buffer.
for img = 1:num_files
    % Get images from file
    if strcmp(rec_type, 'pingpong')
        img1 = imread(['pingpong/00' num2str(img-1,'%02d') '.jpeg']);
        img2 = imread(['pingpong/00' num2str(img,'%02d') '.jpeg']);
    elseif strcmp(rec_type, 'person_toy')
        img1 = imread(['person_toy/00000' num2str(img,'%03d') '.jpg']);
        img2 = imread(['person_toy/00000' num2str(img+1,'%03d') '.jpg']);
    end
    
    % Get optical flow arrows
    [vx, vy] = lucas_kanade_points(img1,img2, r, c, kernel_size);
    
    % C
    fig = figure(img);
    axis equal
    imshow(rgb2gray(img1))
    hold on;
    
    q = quiver(c,r,vx',vy');
    q.Color = 'red';
    q.LineWidth = 1;
    hold on;
    
    plot(c,r,'r.','MarkerSize',15)
    file = [saving_folder num2str(img) '.png'];
    saveas(fig, file);
    pause(0.8);
    close(fig);    
    
    if mod(img, 5) == 0
        [~, r, c] = harris(img2, kernel_size, sigma, window_size, threshold, false);
    end
end


writer = VideoWriter(video_name);
writer.FrameRate = 10;
open(writer);

for file_index = 1:num_files
    file = [saving_folder num2str(file_index,'%d') '.png'];
    frame = imread(file);
    writeVideo(writer, frame);
end

close(writer);