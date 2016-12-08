load('/Volumes/TRANSCEND/Uni/MATLAB/flr_split_mat2/frame1.mat');
load('/Volumes/TRANSCEND/Uni/MATLAB/flr_split_mat2/frame2.mat');
%load('D:\Uni\MATLAB\br_split_mat2\frame1.mat');
%load('D:\Uni\MATLAB\br_split_mat2\frame2.mat');

% frame1 = frame1(:,:,91:120);
% frame2 = frame2(:,:,91:120);
frame1 = frame1(:,:,13:76);
frame2 = frame2(:,:,13:76);

profile on
clear CC_row

img_width = size(frame1,1);
img_height = size(frame1,2);

runs = 10; %how many times do you want to repeat the measurement?
steps = size(frame1,3); %number of datapoints

syms z
syms d

dx_means = zeros(runs,1);
DOCs = zeros(steps,runs);
W_zs = zeros(steps,runs);

for i = 1:runs;
    disp_fun(z) = (0.1*i)*z; %linear disp_fun
    RH_DOC3; %giving DOC
    DOCs(:,i) = DOC;
    dx_means(i) = dx_mean; %storing all dx_means in matrix

    disp_inv = solve(disp_fun == d,z);
    z_focus = zeros(length(disp_inv),1);

    for k = 1:length(disp_inv)
        disp_root = disp_inv(k);
        disp_root(d) = disp_root;
        z_focus(k) = disp_root(dx_mean);
    end

    z_focus = double(mean(z_focus(:)));

    x = (1:steps) - z_focus; %setting z_focus to be 0

    W_z = DOC ./ (double(disp_fun(x)) + DOC);

    W_zs(:,i) = W_z / dx_mean;% normalising W_z
end

surf(W_zs);