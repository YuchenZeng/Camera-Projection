function [result] = F3Dto2D(mode, mocapJoints,vue2,vue4)
%in this function, we input a 3D world coordinate [X,Y,Z], and it will
%project 3D points in to 2D pixel locations

%parameter: output - output X', Y' that is 2D pixel locations

%This function ONLY works in the main.m since <vue2> and <vue4> camera
%parameters would be initialied in the main.m prior of calling this
%function.



% mocapFnum = 1; %mocap frame number 1000 
% x = mocapJoints(mocapFnum,:,1); %array of 12 X coordinates 
% y = mocapJoints(mocapFnum,:,2); % Y coordinates 
% z = mocapJoints(mocapFnum,:,3); % Z coordinates 
% conf = mocapJoints(mocapFnum,:,4); %confidence values
% 
%                 

end