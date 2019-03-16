%initialization of VideoReader for the vue video. 
vue2video = VideoReader('./project2_files/Subject4-Session3-24form-Full-Take4-Vue2.mp4');
vue4video = VideoReader('./project2_files/Subject4-Session3-24form-Full-Take4-Vue4.mp4');

%load in mocap
load('./project2_files/Subject4-Session3-Take4_mocapJoints.mat')

%load in camara parameters
load('./project2_files/vue2CalibInfo.mat');
load('./project2_files/vue4CalibInfo.mat');

%total frame count
Fnum = 26214;

%add gaussian noise
%create 4x12x26214 zeros
m_noise = zeros(4,12,26214);

%add gaussian distributed noise to m_noise with mean 0 and var 1*10^(-18)
m_noise = m_noise + 10^(-18)*randn(size(m_noise));

%transpsoe the mocapJoints matrix. It become 4*12*26214.
mocapJoints_transpose = permute(mocapJoints,[3,2,1]);

%add gauusian noise
mocapJoints_transpose = mocapJoints_transpose + m_noise;

%initilize matrixs and fill with zero. This will give better performance
CAM2_coords = zeros(3,12,Fnum);
CAM4_coords = zeros(3,12,Fnum);
PIXEL2_coords = zeros(3,12,Fnum);
PIXEL4_coords = zeros(3,12,Fnum);
v2 = zeros(3,12,Fnum);
v4 = zeros(3,12,Fnum);

%calculate camera coordinates for each frame in each iteration. 
for i = 1:Fnum
    CAM2_coords(:,:,i) = vue2.Pmat * mocapJoints_transpose(:,:,i);
    CAM4_coords(:,:,i) = vue4.Pmat * mocapJoints_transpose(:,:,i);
end

%x = X/Z, y = Y/Z
%here we are not multiplying the focal length of the camera. the parameter
%<vue2.Kmat> has been multiplyed by the focal length. So we don't have to
%do it at this step. So the film coordinates are missing a scale of focal
%length. 
%temp values will be removed from workspace at the end. 
temp_x = CAM2_coords(1,:,:)./CAM2_coords(3,:,:);
temp_y = CAM2_coords(2,:,:)./CAM2_coords(3,:,:);
temp = ones(1,12,26214);
FILM2_coords = [temp_x;temp_y;temp];

temp_x = CAM4_coords(1,:,:)./CAM4_coords(3,:,:);
temp_y = CAM4_coords(2,:,:)./CAM4_coords(3,:,:);
FILM4_coords = [temp_x;temp_y;temp];

%now we compute pixel locations based on the film coordinates. The Kmat has
%a scale factor of focal length
for i = 1:Fnum
    PIXEL2_coords(:,:,i) = vue2.Kmat * FILM2_coords(:,:,i);
    PIXEL4_coords(:,:,i) = vue4.Kmat * FILM4_coords(:,:,i);
end

%reconstruct 3d world with pixel locations
%c2,c4: camera location
c2 = vue2.position;
c4 = vue4.position;
%now lets get the vector that pointing to the world location of the joint
%that is coming from the camera
%backword projection
temp = transpose(vue2.Rmat) * inv(vue2.Kmat);
for i = 1:Fnum
    v2(:,:,i) = temp * PIXEL2_coords(:,:,i);
end

temp = transpose(vue4.Rmat) * inv(vue4.Kmat);
for i = 1:Fnum
    v4(:,:,i) = temp * PIXEL4_coords(:,:,i);
end
%v2, v4 are the vectors that originate from the camera and point toward the
%joint

%move data back to the RAM from GPU
v2 = gather(v2);
v4 = gather(v4);

%now we calculate the joint point
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
    end
end
%p will be 3*12*26214 that contains all the reconstruced joint points