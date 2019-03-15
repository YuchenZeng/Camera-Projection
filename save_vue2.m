% create a video writer
output_vue2 = VideoWriter(path_vue2);

output_vue2.FrameRate = fps;  % Default 30
output_vue2.Quality = 100;    % Default 75
open(output_vue2);

%create a figure to overlay the video and joint points
f = figure;
f.Position = [10,10,1920/downscale_constant,1080/downscale_constant];
vue2_fps = vue2video.FrameRate;

if (parallel_enable == 1)
    PIXEL2_coords = gpuArray(PIXEL2_coords);
end
for i = 1:(min(sec*fps,26214))
    Frame = i
    f.Name = num2str(i);
    i = 2 * i;
    mocapFnum = i;
    vue2video.CurrentTime = (mocapFnum-1)*(50/100)/vue2_fps;
    vid2Frame = readFrame(vue2video);
    image(vid2Frame);
    hold on;
    plot(PIXEL2_coords(1,:,i),PIXEL2_coords(2,:,i),'r*', 'LineWidth', 2, 'MarkerSize', 5);
    %now we connect joints
    %right shoulder - right elbow - right wrist
    Rarm_x = [PIXEL2_coords(1,1,i),PIXEL2_coords(1,2,i),PIXEL2_coords(1,3,i)];
    Rarm_y = [PIXEL2_coords(2,1,i),PIXEL2_coords(2,2,i),PIXEL2_coords(2,3,i)];
    plot(Rarm_x,Rarm_y,'r', 'LineWidth', 3);
    %left shoulder - left elbow - left wrist
    Larm_x = [PIXEL2_coords(1,4,i),PIXEL2_coords(1,5,i),PIXEL2_coords(1,6,i)];
    Larm_y = [PIXEL2_coords(2,4,i),PIXEL2_coords(2,5,i),PIXEL2_coords(2,6,i)];
    plot(Larm_x,Larm_y,'r', 'LineWidth', 3);
    %Right hip - Right knee - Right ankle
    Rleg_x = [PIXEL2_coords(1,7,i),PIXEL2_coords(1,8,i),PIXEL2_coords(1,9,i)];
    Rleg_y = [PIXEL2_coords(2,7,i),PIXEL2_coords(2,8,i),PIXEL2_coords(2,9,i)];
    plot(Rleg_x,Rleg_y,'r', 'LineWidth', 3);
    %Left hip - Left knee - Left ankle
    Lleg_x = [PIXEL2_coords(1,10,i),PIXEL2_coords(1,11,i),PIXEL2_coords(1,12,i)];
    Lleg_y = [PIXEL2_coords(2,10,i),PIXEL2_coords(2,11,i),PIXEL2_coords(2,12,i)];
    plot(Lleg_x,Lleg_y,'r', 'LineWidth', 3);
    %connect left shoulder - right shoulder
    top_x = [PIXEL2_coords(1,1,i),PIXEL2_coords(1,4,i),];
    top_y = [PIXEL2_coords(2,1,i),PIXEL2_coords(2,4,i),];
    plot(top_x,top_y,'r', 'LineWidth', 3);
    %connect left hip - right hip
    bot_x = [PIXEL2_coords(1,7,i),PIXEL2_coords(1,10,i),];
    bot_y = [PIXEL2_coords(2,7,i),PIXEL2_coords(2,10,i),];
    plot(bot_x,bot_y,'r', 'LineWidth', 3);
    %connect middle of top - middle of bot
    body_x = [(PIXEL2_coords(1,1,i)+PIXEL2_coords(1,4,i))/2,(PIXEL2_coords(1,7,i)+PIXEL2_coords(1,10,i))/2];
    body_y = [(PIXEL2_coords(2,1,i)+PIXEL2_coords(2,4,i))/2,(PIXEL2_coords(2,7,i)+PIXEL2_coords(2,10,i))/2];
    plot(body_x,body_y,'r', 'LineWidth', 3);
    M = getframe(f);
    writeVideo(output_vue2, M);
    hold off;
end
close(output_vue2);
close;
