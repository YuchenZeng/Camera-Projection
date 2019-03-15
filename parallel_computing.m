%reset GPU
reset(gpuDevice(1));

%initialization of VideoReader for the vue video. 
vue2video = VideoReader('./project2_files/Subject4-Session3-24form-Full-Take4-Vue2.mp4');
vue4video = VideoReader('./project2_files/Subject4-Session3-24form-Full-Take4-Vue4.mp4');

%load in mocap
load('./project2_files/Subject4-Session3-Take4_mocapJoints.mat')

%load in camara parameters
load('./project2_files/vue2CalibInfo.mat');
load('./project2_files/vue4CalibInfo.mat');

%Use parallel computing. Move <mocapJoints to the GPU>
mocapJoints = gpuArray(mocapJoints);
mocapJoints_transpose = permute(mocapJoints,[3,2,1]);
%World Coordinates to Camera Coordinates
CAM2_coords = pagefun(@mtimes,vue2.Pmat,mocapJoints_transpose);
CAM4_coords = pagefun(@mtimes,vue4.Pmat,mocapJoints_transpose);

%Camera Coordinates to Film Coordinates
temp_x = CAM2_coords(1,:,:)./CAM2_coords(3,:,:);
temp_y = CAM2_coords(2,:,:)./CAM2_coords(3,:,:);
temp = ones(1,12,26214);
FILM2_coords = [temp_x;temp_y;temp];

temp_x = CAM4_coords(1,:,:)./CAM4_coords(3,:,:);
temp_y = CAM4_coords(2,:,:)./CAM4_coords(3,:,:);
FILM4_coords = [temp_x;temp_y;temp];

%Film Coordinates to Pixel Coordinates

PIXEL2_coords = pagefun(@mtimes,vue2.Kmat,FILM2_coords);
PIXEL4_coords = pagefun(@mtimes,vue4.Kmat,FILM4_coords);

%reconstruct 3d world with pixel locations
%c2,c4: camera location
c2 = vue2.position;
c4 = vue4.position;
%now lets get the vector that pointing to the world location of the joint
%that is coming from the camera
temp = transpose(vue2.Rmat) * inv(vue2.Kmat);
v2 = pagefun(@mtimes,temp,PIXEL2_coords);
temp = transpose(vue4.Rmat) * inv(vue4.Kmat);
v4 = pagefun(@mtimes,temp,PIXEL4_coords);
%move data back to the RAM from GPU
v2 = gather(v2);
v4 = gather(v4);
%now we calculate the point
for i1 = 1:26214
    for i2 = 1:12
        %<_n>: normalized vector
        v2_n = v2(:,i2,i1)./norm(v2(:,i2,i1));
        v4_n = v4(:,i2,i1)./norm(v4(:,i2,i1));
        v3_n = cross(v2_n,v4_n)./norm(cross(v2_n,v4_n));
        temp = [v2_n,v3_n,-v4_n];
        result = linsolve(temp,(c4-c2).');
        p1 = c2.' + result(1,1) .* v2_n;
        p2 = c4.' + result(3,1) .* v4_n;
        p(:,i2,i1) = (p1+p2)/2;
        %p will be 3*12*26214 that contains all the reconstruced joint points
    end
end

%now we copy all the data from the GPU back to the RAM
CAM2_coords = gather(CAM2_coords);
CAM4_coords = gather(CAM4_coords);
FILM2_coords = gather(FILM2_coords);
FILM4_coords = gather(FILM4_coords);
mocapJoints = gather(mocapJoints);
mocapJoints_transpose = gather(mocapJoints_transpose);
PIXEL2_coords = gather(PIXEL2_coords);
PIXEL4_coords = gather(PIXEL4_coords);

clear temp temp_x temp_y i1 i2