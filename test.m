%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rarm_x = [PIXEL4_coords(1,1,i),PIXEL4_coords(1,2,i),PIXEL4_coords(1,3,i)] .* PIXEL4_coords(4,1,i) .* PIXEL4_coords(4,2,i) .* PIXEL4_coords(4,3,i);
Rarm_y = [PIXEL4_coords(2,1,i),PIXEL4_coords(2,2,i),PIXEL4_coords(2,3,i)] .* PIXEL4_coords(4,1,i) .* PIXEL4_coords(4,2,i) .* PIXEL4_coords(4,3,i);
Rarm_z = [PIXEL4_coords(3,1,i),PIXEL4_coords(3,2,i),PIXEL4_coords(3,3,i)] .* PIXEL4_coords(4,1,i) .* PIXEL4_coords(4,2,i) .* PIXEL4_coords(4,3,i);
plot3(Rarm_x,Rarm_y,Rarm_z,'b', 'LineWidth', 1);
hold on;

%left shoulder - left elbow - left wrist
Larm_x = [PIXEL4_coords(1,4,i),PIXEL4_coords(1,5,i),PIXEL4_coords(1,6,i)] .* PIXEL4_coords(4,4,i) .* PIXEL4_coords(4,5,i) .* PIXEL4_coords(4,6,i);
Larm_y = [PIXEL4_coords(2,4,i),PIXEL4_coords(2,5,i),PIXEL4_coords(2,6,i)] .* PIXEL4_coords(4,4,i) .* PIXEL4_coords(4,5,i) .* PIXEL4_coords(4,6,i);
Larm_z = [PIXEL4_coords(3,4,i),PIXEL4_coords(3,5,i),PIXEL4_coords(3,6,i)] .* PIXEL4_coords(4,4,i) .* PIXEL4_coords(4,5,i) .* PIXEL4_coords(4,6,i);
plot3(Larm_x,Larm_y,Larm_z,'b', 'LineWidth', 1);
%Right hip - Right knee - Right ankle
Rleg_x = [PIXEL4_coords(1,7,i),PIXEL4_coords(1,8,i),PIXEL4_coords(1,9,i)] .* PIXEL4_coords(4,7,i) .* PIXEL4_coords(4,8,i) .* PIXEL4_coords(4,9,i);
Rleg_y = [PIXEL4_coords(2,7,i),PIXEL4_coords(2,8,i),PIXEL4_coords(2,9,i)] .* PIXEL4_coords(4,7,i) .* PIXEL4_coords(4,8,i) .* PIXEL4_coords(4,9,i);
Rleg_z = [PIXEL4_coords(3,7,i),PIXEL4_coords(3,8,i),PIXEL4_coords(3,9,i)] .* PIXEL4_coords(4,7,i) .* PIXEL4_coords(4,8,i) .* PIXEL4_coords(4,9,i);
plot3(Rleg_x,Rleg_y,Rleg_z,'b', 'LineWidth', 1);
%Left hip - Left knee - Left ankle
Lleg_x = [PIXEL4_coords(1,10,i),PIXEL4_coords(1,11,i),PIXEL4_coords(1,12,i)] .* PIXEL4_coords(4,10,i) .* PIXEL4_coords(4,11,i) .* PIXEL4_coords(4,12,i);
Lleg_y = [PIXEL4_coords(2,10,i),PIXEL4_coords(2,11,i),PIXEL4_coords(2,12,i)] .* PIXEL4_coords(4,10,i) .* PIXEL4_coords(4,11,i) .* PIXEL4_coords(4,12,i);
Lleg_z = [PIXEL4_coords(3,10,i),PIXEL4_coords(3,11,i),PIXEL4_coords(3,12,i)] .* PIXEL4_coords(4,10,i) .* PIXEL4_coords(4,11,i) .* PIXEL4_coords(4,12,i);
plot3(Lleg_x,Lleg_y,Lleg_z,'b', 'LineWidth', 1);
%connect left shoulder - right shoulder
top_x = [PIXEL4_coords(1,1,i),PIXEL4_coords(1,4,i)] .* PIXEL4_coords(4,1,i) .* PIXEL4_coords(4,4,i);
top_y = [PIXEL4_coords(2,1,i),PIXEL4_coords(2,4,i)] .* PIXEL4_coords(4,1,i) .* PIXEL4_coords(4,4,i);
top_z = [PIXEL4_coords(3,1,i),PIXEL4_coords(3,4,i)] .* PIXEL4_coords(4,1,i) .* PIXEL4_coords(4,4,i);
plot3(top_x,top_y,top_z,'b', 'LineWidth', 1);
%connect left hip - right hip
bot_x = [PIXEL4_coords(1,7,i),PIXEL4_coords(1,10,i)] .* PIXEL4_coords(4,7,i) .* PIXEL4_coords(4,10,i);
bot_y = [PIXEL4_coords(2,7,i),PIXEL4_coords(2,10,i)] .* PIXEL4_coords(4,7,i) .* PIXEL4_coords(4,10,i);
bot_z = [PIXEL4_coords(3,7,i),PIXEL4_coords(3,10,i)] .* PIXEL4_coords(4,7,i) .* PIXEL4_coords(4,10,i);
plot3(bot_x,bot_y,bot_z,'b', 'LineWidth', 1);
%connect middle of top - middle of bot
body_x = [(PIXEL4_coords(1,1,i)+PIXEL4_coords(1,4,i))/2,(PIXEL4_coords(1,7,i)+PIXEL4_coords(1,10,i))/2] .* PIXEL4_coords(4,1,i) .* PIXEL4_coords(4,4,i)  .* PIXEL4_coords(4,7,i) .* PIXEL4_coords(4,10,i);
body_y = [(PIXEL4_coords(2,1,i)+PIXEL4_coords(2,4,i))/2,(PIXEL4_coords(2,7,i)+PIXEL4_coords(2,10,i))/2] .* PIXEL4_coords(4,1,i) .* PIXEL4_coords(4,4,i)  .* PIXEL4_coords(4,7,i) .* PIXEL4_coords(4,10,i);
body_z = [(PIXEL4_coords(3,1,i)+PIXEL4_coords(3,4,i))/2,(PIXEL4_coords(3,7,i)+PIXEL4_coords(3,10,i))/2] .* PIXEL4_coords(4,1,i) .* PIXEL4_coords(4,4,i)  .* PIXEL4_coords(4,7,i) .* PIXEL4_coords(4,10,i);
plot3(body_x,body_y,body_z,'b', 'LineWidth', 1);

 view(0,90);
% xlim([0 1920]);
% ylim([0 1080]);
% zlim([0 2500]);

% view(280,-10);
% xlim([-2100 2500]);
% ylim([-2400 2500]);
% zlim([0 2500]);
xlabel('x-axis')
ylabel('y-axis')
zlabel('z-axis')