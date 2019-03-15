% create a video writer
output_vue2 = VideoWriter(path_vue2);

%parameters that changes video quality
output_vue2.FrameRate = fps;  % Default 30
output_vue2.Quality = 100;    % Default 75
open(output_vue2);

%create a figure to overlay the video and joint points
f1 = figure;
f1.Position = [10,10,1920/downscale_constant,1080/downscale_constant];
vue2_fps = vue2video.FrameRate;

%using parallel computing will gain ~-3s each 100 frame generated
if (parallel_enable == 1)
    PIXEL2_coords = gpuArray(PIXEL2_coords);
end

%because the original video is captured at 50fps, using 100fps is not
%helping since 2 frames will have same information. 
for i = 1:(min(sec*fps,26214))
    Frame = i
    f1.Name = num2str(i);
    f = 2 * i;
    mocapFnum = f;
    vue2video.CurrentTime = (mocapFnum-1)*(50/100)/vue2_fps;
    vid2Frame = readFrame(vue2video);
    image(vid2Frame);
    hold on;
    plot(PIXEL2_coords(1,:,f),PIXEL2_coords(2,:,f),'r*', 'LineWidth', 2, 'MarkerSize', 5);
    %now we connect joints
    %right shoulder - right elbow - right wrist
    Rarm_x = [PIXEL2_coords(1,1,f),PIXEL2_coords(1,2,f),PIXEL2_coords(1,3,f)];
    Rarm_y = [PIXEL2_coords(2,1,f),PIXEL2_coords(2,2,f),PIXEL2_coords(2,3,f)];
    plot(Rarm_x,Rarm_y,'r', 'LineWidth', 3);
    %left shoulder - left elbow - left wrist
    Larm_x = [PIXEL2_coords(1,4,f),PIXEL2_coords(1,5,f),PIXEL2_coords(1,6,f)];
    Larm_y = [PIXEL2_coords(2,4,f),PIXEL2_coords(2,5,f),PIXEL2_coords(2,6,f)];
    plot(Larm_x,Larm_y,'r', 'LineWidth', 3);
    %Right hip - Right knee - Right ankle
    Rleg_x = [PIXEL2_coords(1,7,f),PIXEL2_coords(1,8,f),PIXEL2_coords(1,9,f)];
    Rleg_y = [PIXEL2_coords(2,7,f),PIXEL2_coords(2,8,f),PIXEL2_coords(2,9,f)];
    plot(Rleg_x,Rleg_y,'r', 'LineWidth', 3);
    %Left hip - Left knee - Left ankle
    Lleg_x = [PIXEL2_coords(1,10,f),PIXEL2_coords(1,11,f),PIXEL2_coords(1,12,f)];
    Lleg_y = [PIXEL2_coords(2,10,f),PIXEL2_coords(2,11,f),PIXEL2_coords(2,12,f)];
    plot(Lleg_x,Lleg_y,'r', 'LineWidth', 3);
    %connect left shoulder - right shoulder
    top_x = [PIXEL2_coords(1,1,f),PIXEL2_coords(1,4,f),];
    top_y = [PIXEL2_coords(2,1,f),PIXEL2_coords(2,4,f),];
    plot(top_x,top_y,'r', 'LineWidth', 3);
    %connect left hip - right hip
    bot_x = [PIXEL2_coords(1,7,f),PIXEL2_coords(1,10,f),];
    bot_y = [PIXEL2_coords(2,7,f),PIXEL2_coords(2,10,f),];
    plot(bot_x,bot_y,'r', 'LineWidth', 3);
    %connect middle of top - middle of bot
    body_x = [(PIXEL2_coords(1,1,f)+PIXEL2_coords(1,4,f))/2,(PIXEL2_coords(1,7,f)+PIXEL2_coords(1,10,f))/2];
    body_y = [(PIXEL2_coords(2,1,f)+PIXEL2_coords(2,4,f))/2,(PIXEL2_coords(2,7,f)+PIXEL2_coords(2,10,f))/2];
    plot(body_x,body_y,'r', 'LineWidth', 3);
    M = getframe(f1);
    writeVideo(output_vue2, M);
    hold off;
end
close(output_vue2);
close;
