addpath('./project2_files');    %include given files

format longG
num = 200;

vue2_fps = vue2video.FrameRate;

for i = 1:num
    i
    mocapFnum = i;
    vue2video.CurrentTime = (mocapFnum-1)*(50/100)/vue2_fps;
    vid2Frame = readFrame(vue2video);
    m(i,:,:,:) = vid2Frame;
    fnum = 20*i-1;
    parfor i2= fnum:fnum+19
        
    end
end
