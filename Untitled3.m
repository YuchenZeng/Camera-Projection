myVideo = VideoWriter('myfile.avi');
myVideo.FrameRate = 100;  % Default 30
myVideo.Quality = 100;    % Default 75
open(myVideo);
writeVideo(myVideo, M);
close(myVideo);