addpath('./project2_files');    %include given files
clc;clear;                      %clean workspace and clear command line window
reset(gpuDevice(1));
format longG                    %show long decimal number without scientific notation in commandmyVideo = VideoWriter('myfile.avi');

output_vue2 = VideoWriter('output_vue2.avi');
output_vue2.FrameRate = 100;  % Default 30
output_vue2.Quality = 100;    % Default 75
open(output_vue2);


%initialization of VideoReader for the vue video. 
%YOU ONLY NEED TO DO THIS ONCE AT THE BEGINNING
vue2video = VideoReader('./project2_files/Subject4-Session3-24form-Full-Take4-Vue2.mp4');
vue4video = VideoReader('./project2_files/Subject4-Session3-24form-Full-Take4-Vue4.mp4');

%load in mocap
load('./project2_files/Subject4-Session3-Take4_mocapJoints.mat')

%load in camara parameters
load('./project2_files/vue2CalibInfo.mat');
load('./project2_files/vue4CalibInfo.mat');

%Use parallel computing
mocapJoints = gpuArray(mocapJoints);
mocapJoints_transpose = permute(mocapJoints,[3,2,1]);
%World Coordinates to Camera Coordinates
CAM2_coords = pagefun(@mtimes,vue2.Pmat,mocapJoints_transpose);
CAM4_coords = pagefun(@mtimes,vue4.Pmat,mocapJoints_transpose);

%Camera Coordinates to Film Coordinates
temp_x = CAM2_coords(1,:,:)./CAM2_coords(3,:,:);
temp_y = CAM2_coords(2,:,:)./CAM2_coords(3,:,:);
temp = ones(1,12,26214);
FILM2_coords = [temp_x;temp_y;temp];

temp_x = CAM4_coords(1,:,:)./CAM4_coords(3,:,:);
temp_y = CAM4_coords(2,:,:)./CAM4_coords(3,:,:);
FILM4_coords = [temp_x;temp_y;temp];

%Film Coordinates to Pixel Coordinates

PIXEL2_coords = pagefun(@mtimes,vue2.Kmat,FILM2_coords);
PIXEL4_coords = pagefun(@mtimes,vue4.Kmat,FILM4_coords);
PIXEL2_coords = gather(PIXEL2_coords);
PIXEL4_coords = gather(PIXEL4_coords);

%result = F3Dto2D(0,mocapJoints, vue2, vue4);



%now we can read in the video for any mocap frame mocapFnum. the (50/100)
%factor is here to account for the difference in frame %rates between video
%(50 fps) and mocap (100 fps).
f = figure;
f.Position = [500,500,1920/2,1080/2];
vue2_fps = vue2video.FrameRate;

profile on
parfor i = 1:100
    i
    f.Name = num2str(i);
    mocapFnum = i;
    vue2video.CurrentTime = (mocapFnum-1)*(50/100)/vue2_fps;
    vid2Frame = readFrame(vue2video);
    image(vid2Frame);
    hold on;
    plot(PIXEL2_coords(1,:,i),PIXEL2_coords(2,:,i),'r*', 'LineWidth', 2, 'MarkerSize', 5);
    M = getframe(f);
    writeVideo(output_vue2, M);
    hold off;
end
profile off
close(output_vue2);
close;
    

%/////////////////////////////////////////////////////////////////////////





