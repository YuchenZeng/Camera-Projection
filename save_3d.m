% create a video writer
output_video = VideoWriter(path_3d);

output_video.FrameRate = 100;  % Default 30
output_video.Quality = 100;    % Default 75
open(output_video);

%create a figure to overlay the video and joint points
%f = figure;
%f.Position = [500,500,1920/downscale_constant,1080/downscale_constant];

%move data to GPU if parallel computing is enabled. Using GPU will gain ~-3s
%per 100 frame generation. 
if (parallel_enable == 1)
    p = gpuArray(p);
end

for i = 1:(min(sec*100,26214))
    Frame = i
    
    %now let's draw the reconstruced joints
    %now we connect joints
    %right shoulder - right elbow - right wrist
    Rarm_x = [p(1,1,i),p(1,2,i),p(1,3,i)];
    Rarm_y = [p(2,1,i),p(2,2,i),p(2,3,i)];
    Rarm_z = [p(3,1,i),p(3,2,i),p(3,3,i)];
    plot3(Rarm_x,Rarm_y,Rarm_z,'r', 'LineWidth', 2);
    hold on;
    %left shoulder - left elbow - left wrist
    Larm_x = [p(1,4,i),p(1,5,i),p(1,6,i)];
    Larm_y = [p(2,4,i),p(2,5,i),p(2,6,i)];
    Larm_z = [p(3,4,i),p(3,5,i),p(3,6,i)];
    plot3(Larm_x,Larm_y,Larm_z,'r', 'LineWidth', 2);
    %Right hip - Right knee - Right ankle
    Rleg_x = [p(1,7,i),p(1,8,i),p(1,9,i)];
    Rleg_y = [p(2,7,i),p(2,8,i),p(2,9,i)];
    Rleg_z = [p(3,7,i),p(3,8,i),p(3,9,i)];
    plot3(Rleg_x,Rleg_y,Rleg_z,'r', 'LineWidth', 2);
    %Left hip - Left knee - Left ankle
    Lleg_x = [p(1,10,i),p(1,11,i),p(1,12,i)];
    Lleg_y = [p(2,10,i),p(2,11,i),p(2,12,i)];
    Lleg_z = [p(3,10,i),p(3,11,i),p(3,12,i)];
    plot3(Lleg_x,Lleg_y,Lleg_z,'r', 'LineWidth', 2);
    %connect left shoulder - right shoulder
    top_x = [p(1,1,i),p(1,4,i)];
    top_y = [p(2,1,i),p(2,4,i)];
    top_z = [p(3,1,i),p(3,4,i)];
    plot3(top_x,top_y,top_z,'r', 'LineWidth', 2);
    %connect left hip - right hip
    bot_x = [p(1,7,i),p(1,10,i)];
    bot_y = [p(2,7,i),p(2,10,i)];
    bot_z = [p(3,7,i),p(3,10,i)];
    plot3(bot_x,bot_y,bot_z,'r', 'LineWidth', 2);
    %connect middle of top - middle of bot
    body_x = [(p(1,1,i)+p(1,4,i))/2,(p(1,7,i)+p(1,10,i))/2];
    body_y = [(p(2,1,i)+p(2,4,i))/2,(p(2,7,i)+p(2,10,i))/2];
    body_z = [(p(3,1,i)+p(3,4,i))/2,(p(3,7,i)+p(3,10,i))/2];
    plot3(body_x,body_y,body_z,'r', 'LineWidth', 2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %now let's draw the original joints
    %after calculating the x,y,z we multiple the value by the confidence in
    %order to eliminate points that does not exist
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Rarm_x = [mocapJoints_transpose(1,1,i),mocapJoints_transpose(1,2,i),mocapJoints_transpose(1,3,i)] .* mocapJoints_transpose(4,1,i) .* mocapJoints_transpose(4,2,i) .* mocapJoints_transpose(4,3,i)
    Rarm_y = [mocapJoints_transpose(2,1,i),mocapJoints_transpose(2,2,i),mocapJoints_transpose(2,3,i)] .* mocapJoints_transpose(4,1,i) .* mocapJoints_transpose(4,2,i) .* mocapJoints_transpose(4,3,i);
    Rarm_z = [mocapJoints_transpose(3,1,i),mocapJoints_transpose(3,2,i),mocapJoints_transpose(3,3,i)] .* mocapJoints_transpose(4,1,i) .* mocapJoints_transpose(4,2,i) .* mocapJoints_transpose(4,3,i);
    plot3(Rarm_x,Rarm_y,Rarm_z,'b', 'LineWidth', 1);
    
    %left shoulder - left elbow - left wrist
    Larm_x = [mocapJoints_transpose(1,4,i),mocapJoints_transpose(1,5,i),mocapJoints_transpose(1,6,i)] .* mocapJoints_transpose(4,4,i) .* mocapJoints_transpose(4,5,i) .* mocapJoints_transpose(4,6,i);
    Larm_y = [mocapJoints_transpose(2,4,i),mocapJoints_transpose(2,5,i),mocapJoints_transpose(2,6,i)] .* mocapJoints_transpose(4,4,i) .* mocapJoints_transpose(4,5,i) .* mocapJoints_transpose(4,6,i);
    Larm_z = [mocapJoints_transpose(3,4,i),mocapJoints_transpose(3,5,i),mocapJoints_transpose(3,6,i)] .* mocapJoints_transpose(4,4,i) .* mocapJoints_transpose(4,5,i) .* mocapJoints_transpose(4,6,i);
    plot3(Larm_x,Larm_y,Larm_z,'b', 'LineWidth', 1);
    %Right hip - Right knee - Right ankle
    Rleg_x = [mocapJoints_transpose(1,7,i),mocapJoints_transpose(1,8,i),mocapJoints_transpose(1,9,i)] .* mocapJoints_transpose(4,7,i) .* mocapJoints_transpose(4,8,i) .* mocapJoints_transpose(4,9,i);
    Rleg_y = [mocapJoints_transpose(2,7,i),mocapJoints_transpose(2,8,i),mocapJoints_transpose(2,9,i)] .* mocapJoints_transpose(4,7,i) .* mocapJoints_transpose(4,8,i) .* mocapJoints_transpose(4,9,i);
    Rleg_z = [mocapJoints_transpose(3,7,i),mocapJoints_transpose(3,8,i),mocapJoints_transpose(3,9,i)] .* mocapJoints_transpose(4,7,i) .* mocapJoints_transpose(4,8,i) .* mocapJoints_transpose(4,9,i);
    plot3(Rleg_x,Rleg_y,Rleg_z,'b', 'LineWidth', 1);
    %Left hip - Left knee - Left ankle
    Lleg_x = [mocapJoints_transpose(1,10,i),mocapJoints_transpose(1,11,i),mocapJoints_transpose(1,12,i)] .* mocapJoints_transpose(4,10,i) .* mocapJoints_transpose(4,11,i) .* mocapJoints_transpose(4,12,i);
    Lleg_y = [mocapJoints_transpose(2,10,i),mocapJoints_transpose(2,11,i),mocapJoints_transpose(2,12,i)] .* mocapJoints_transpose(4,10,i) .* mocapJoints_transpose(4,11,i) .* mocapJoints_transpose(4,12,i);
    Lleg_z = [mocapJoints_transpose(3,10,i),mocapJoints_transpose(3,11,i),mocapJoints_transpose(3,12,i)] .* mocapJoints_transpose(4,10,i) .* mocapJoints_transpose(4,11,i) .* mocapJoints_transpose(4,12,i);
    plot3(Lleg_x,Lleg_y,Lleg_z,'b', 'LineWidth', 1);
    %connect left shoulder - right shoulder
    top_x = [mocapJoints_transpose(1,1,i),mocapJoints_transpose(1,4,i)] .* mocapJoints_transpose(4,1,i) .* mocapJoints_transpose(4,4,i);
    top_y = [mocapJoints_transpose(2,1,i),mocapJoints_transpose(2,4,i)] .* mocapJoints_transpose(4,1,i) .* mocapJoints_transpose(4,4,i);
    top_z = [mocapJoints_transpose(3,1,i),mocapJoints_transpose(3,4,i)] .* mocapJoints_transpose(4,1,i) .* mocapJoints_transpose(4,4,i);
    plot3(top_x,top_y,top_z,'b', 'LineWidth', 1);
    %connect left hip - right hip
    bot_x = [mocapJoints_transpose(1,7,i),mocapJoints_transpose(1,10,i)] .* mocapJoints_transpose(4,7,i) .* mocapJoints_transpose(4,10,i);
    bot_y = [mocapJoints_transpose(2,7,i),mocapJoints_transpose(2,10,i)] .* mocapJoints_transpose(4,7,i) .* mocapJoints_transpose(4,10,i);
    bot_z = [mocapJoints_transpose(3,7,i),mocapJoints_transpose(3,10,i)] .* mocapJoints_transpose(4,7,i) .* mocapJoints_transpose(4,10,i);
    plot3(bot_x,bot_y,bot_z,'b', 'LineWidth', 1);
    %connect middle of top - middle of bot
    body_x = [(mocapJoints_transpose(1,1,i)+mocapJoints_transpose(1,4,i))/2,(mocapJoints_transpose(1,7,i)+mocapJoints_transpose(1,10,i))/2] .* mocapJoints_transpose(4,1,i) .* mocapJoints_transpose(4,4,i)  .* mocapJoints_transpose(4,7,i) .* mocapJoints_transpose(4,10,i);
    body_y = [(mocapJoints_transpose(2,1,i)+mocapJoints_transpose(2,4,i))/2,(mocapJoints_transpose(2,7,i)+mocapJoints_transpose(2,10,i))/2] .* mocapJoints_transpose(4,1,i) .* mocapJoints_transpose(4,4,i)  .* mocapJoints_transpose(4,7,i) .* mocapJoints_transpose(4,10,i);
    body_z = [(mocapJoints_transpose(3,1,i)+mocapJoints_transpose(3,4,i))/2,(mocapJoints_transpose(3,7,i)+mocapJoints_transpose(3,10,i))/2] .* mocapJoints_transpose(4,1,i) .* mocapJoints_transpose(4,4,i)  .* mocapJoints_transpose(4,7,i) .* mocapJoints_transpose(4,10,i);   
    plot3(body_x,body_y,body_z,'b', 'LineWidth', 1);
    
    view(280,-10);
    xlim([0 2500]);
    ylim([0 2500]);
    zlim([0 2500]);
    xlabel('x-axis')
    ylabel('y-axis')
    zlabel('z-axis')
    M = getframe(gcf);
    writeVideo(output_video, M);
    hold off;
end

close(output_video);
close;
