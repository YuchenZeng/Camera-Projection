% create a video writer
output_video = VideoWriter(path_vue4);

output_video.FrameRate = fps;  % Default 30
output_video.Quality = 100;    % Default 75
open(output_video);

%create a figure to overlay the video and joint points
f = figure;
f.Position = [500,500,1920/downscale_constant,1080/downscale_constant];
vue4_fps = vue4video.FrameRate;

%move data to GPU if parallel computing is enabled. Using GPU will gain ~-3s
%per 100 frame generation. 
if (parallel_enable == 1)
    PIXEL4_coords = gpuArray(PIXEL4_coords);
end

for i = 1:(min(sec*fps,26214))
    Frame = i
    i = 2 * i;
    f.Name = num2str(i);
    mocapFnum = i;
    vue4video.CurrentTime = (mocapFnum-1)*(50/100)/vue4_fps;
    vid2Frame = readFrame(vue4video);
    image(vid2Frame);
    hold on;
    plot(PIXEL4_coords(1,:,i),PIXEL4_coords(2,:,i),'r*', 'LineWidth', 2, 'MarkerSize', 5);
    %now we connect joints
    %right shoulder - right elbow - right wrist
    Rarm_x = [PIXEL4_coords(1,1,i),PIXEL4_coords(1,2,i),PIXEL4_coords(1,3,i)];
    Rarm_y = [PIXEL4_coords(2,1,i),PIXEL4_coords(2,2,i),PIXEL4_coords(2,3,i)];
    plot(Rarm_x,Rarm_y,'r', 'LineWidth', 3);
    %left shoulder - left elbow - left wrist
    Larm_x = [PIXEL4_coords(1,4,i),PIXEL4_coords(1,5,i),PIXEL4_coords(1,6,i)];
    Larm_y = [PIXEL4_coords(2,4,i),PIXEL4_coords(2,5,i),PIXEL4_coords(2,6,i)];
    plot(Larm_x,Larm_y,'r', 'LineWidth', 3);
    %Right hip - Right knee - Right ankle
    Rleg_x = [PIXEL4_coords(1,7,i),PIXEL4_coords(1,8,i),PIXEL4_coords(1,9,i)];
    Rleg_y = [PIXEL4_coords(2,7,i),PIXEL4_coords(2,8,i),PIXEL4_coords(2,9,i)];
    plot(Rleg_x,Rleg_y,'r', 'LineWidth', 3);
    %Left hip - Left knee - Left ankle
    Lleg_x = [PIXEL4_coords(1,10,i),PIXEL4_coords(1,11,i),PIXEL4_coords(1,12,i)];
    Lleg_y = [PIXEL4_coords(2,10,i),PIXEL4_coords(2,11,i),PIXEL4_coords(2,12,i)];
    plot(Lleg_x,Lleg_y,'r', 'LineWidth', 3);
    %connect left shoulder - right shoulder
    top_x = [PIXEL4_coords(1,1,i),PIXEL4_coords(1,4,i),];
    top_y = [PIXEL4_coords(2,1,i),PIXEL4_coords(2,4,i),];
    plot(top_x,top_y,'r', 'LineWidth', 3);
    %connect left hip - right hip
    bot_x = [PIXEL4_coords(1,7,i),PIXEL4_coords(1,10,i),];
    bot_y = [PIXEL4_coords(2,7,i),PIXEL4_coords(2,10,i),];
    plot(bot_x,bot_y,'r', 'LineWidth', 3);
    %connect middle of top - middle of bot
    body_x = [(PIXEL4_coords(1,1,i)+PIXEL4_coords(1,4,i))/2,(PIXEL4_coords(1,7,i)+PIXEL4_coords(1,10,i))/2];
    body_y = [(PIXEL4_coords(2,1,i)+PIXEL4_coords(2,4,i))/2,(PIXEL4_coords(2,7,i)+PIXEL4_coords(2,10,i))/2];
    plot(body_x,body_y,'r', 'LineWidth', 3);
    M = getframe(f);
    writeVideo(output_video, M);
    hold off;
end

close(output_video);
close;
