% create a video writer
output_video = VideoWriter(path_vue4);

output_video.FrameRate = fps;  % Default 30
output_video.Quality = 100;    % Default 75
open(output_video);

%create a figure to overlay the video and joint points
f1 = figure;
f1.Position = [10,10,1920/downscale_constant,1080/downscale_constant];
vue4_fps = vue4video.FrameRate;

%move data to GPU if parallel computing is enabled. Using GPU will gain ~-3s
%per 100 frame generation. 
if (parallel_enable == 1)
    PIXEL4_coords = gpuArray(PIXEL4_coords);
end

for i = 1:(min(sec*fps,26212))
    Frame = i
    f = 2 * i;
    f1.Name = num2str(i);
    mocapFnum = f;
    vue4video.CurrentTime = (mocapFnum-1)*(50/100)/vue4_fps;
    vid2Frame = readFrame(vue4video);
    image(vid2Frame);
    hold on;
    plot(PIXEL4_coords(1,:,f),PIXEL4_coords(2,:,f),'r*', 'LineWidth', 2, 'MarkerSize', 5);
    %now we connect joints
    %right shoulder - right elbow - right wrist
    Rarm_x = [PIXEL4_coords(1,1,f),PIXEL4_coords(1,2,f),PIXEL4_coords(1,3,f)];
    Rarm_y = [PIXEL4_coords(2,1,f),PIXEL4_coords(2,2,f),PIXEL4_coords(2,3,f)];
    plot(Rarm_x,Rarm_y,'r', 'LineWidth', 3);
    %left shoulder - left elbow - left wrist
    Larm_x = [PIXEL4_coords(1,4,f),PIXEL4_coords(1,5,f),PIXEL4_coords(1,6,f)];
    Larm_y = [PIXEL4_coords(2,4,f),PIXEL4_coords(2,5,f),PIXEL4_coords(2,6,f)];
    plot(Larm_x,Larm_y,'r', 'LineWidth', 3);
    %Right hip - Right knee - Right ankle
    Rleg_x = [PIXEL4_coords(1,7,f),PIXEL4_coords(1,8,f),PIXEL4_coords(1,9,f)];
    Rleg_y = [PIXEL4_coords(2,7,f),PIXEL4_coords(2,8,f),PIXEL4_coords(2,9,f)];
    plot(Rleg_x,Rleg_y,'r', 'LineWidth', 3);
    %Left hip - Left knee - Left ankle
    Lleg_x = [PIXEL4_coords(1,10,f),PIXEL4_coords(1,11,f),PIXEL4_coords(1,12,f)];
    Lleg_y = [PIXEL4_coords(2,10,f),PIXEL4_coords(2,11,f),PIXEL4_coords(2,12,f)];
    plot(Lleg_x,Lleg_y,'r', 'LineWidth', 3);
    %connect left shoulder - right shoulder
    top_x = [PIXEL4_coords(1,1,f),PIXEL4_coords(1,4,f),];
    top_y = [PIXEL4_coords(2,1,f),PIXEL4_coords(2,4,f),];
    plot(top_x,top_y,'r', 'LineWidth', 3);
    %connect left hip - right hip
    bot_x = [PIXEL4_coords(1,7,f),PIXEL4_coords(1,10,f),];
    bot_y = [PIXEL4_coords(2,7,f),PIXEL4_coords(2,10,f),];
    plot(bot_x,bot_y,'r', 'LineWidth', 3);
    %connect middle of top - middle of bot
    body_x = [(PIXEL4_coords(1,1,f)+PIXEL4_coords(1,4,f))/2,(PIXEL4_coords(1,7,f)+PIXEL4_coords(1,10,f))/2];
    body_y = [(PIXEL4_coords(2,1,f)+PIXEL4_coords(2,4,f))/2,(PIXEL4_coords(2,7,f)+PIXEL4_coords(2,10,f))/2];
    plot(body_x,body_y,'r', 'LineWidth', 3);
    M = getframe(f1);
    writeVideo(output_video, M);
    hold off;
end

close(output_video);
close;
