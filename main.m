addpath('./project2_files');    %include given files
clc;clear;                      %clean workspace and clear command line window
format longG                    %show long decimal number without scientific notation in command

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This parameter determine whether to use parallel computing tool box or
%not. There are two scripts doing the same thing, <parallel_computing.m>
%and <for_loop.m>. They are essentially doing the same thing. 
%1 => enable parallel computing
%0 => disable parallel computing, use for loop
%parallel computing is only available if you have a Nvidia GPU
%for_loop should work on any platform.
parallel_enable = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%use <profile viewer> to check performance
profile on
if (parallel_enable == 1)
    run('./parallel_computing.m');
elseif (parallel_enable == 0)
    run('./for_loop.m');
else
    error("<parallel_enable> not recognized")
end
profile off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%at this point, all the computations have been finished
%Let's calculate errors of our result
%d = sqrt((X-X')^2 + (Y-Y')^2 + (Z-Z')^2).
d = zeros(12,26214);
for i1 = 1:12
    for i2 = 1:26214
        d(i1,i2) = sqrt((p(1,i1,i2)-mocapJoints_transpose(1,i1,i2))^2 + (p(2,i1,i2)-mocapJoints_transpose(2,i1,i2))^2 + (p(3,i1,i2)-mocapJoints_transpose(3,i1,i2))^2);
    end
end
%save the <d> to a excel spreadsheet
d = d.'; %transpose
xlswrite('./Euclidean_test.xlsx',d,"A1,L26214")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now we save the videos. The script "save_<>.m will do the work"
%first, let's set parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1. video save path
path_vue2 = './output_vue2.avi';
path_vue4 = './utput_vue4.avi';
path_3d = './output_3d.avi';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2. how long would you like the generate the video. 
sec = 60;
%Maximum shuold be 262 since that's video length. Larger the value longer
%it take
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3. set quality of the generated video.
downscale_constant = 2;
%<1> - no downscale. Full resolution(1920*1080)
%<2> - half resolution
%<3> - one third resoluion
%etc. Larger the value, shorter it take but video quality is worse.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fps = 50;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%run the scripts
run('./save_vue2.m')
%run('./save_vue4.m')
%run('./save_3d.m')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





