load('/Users/Zwiebelsalz/Documents/PIV-Project/Bf_images/frame1.mat');
load('/Users/Zwiebelsalz/Documents/PIV-Project/Bf_images/frame2.mat');

profile on
clear CC_row

% frame1 = frame1(:,:,86:134);
% frame2 = frame2(:,:,86:134);

% frame1 = frame1 + abs(min(frame1(:)));
% frame2 = frame2 + abs(min(frame1(:)));

img_width = size(frame1,1);
img_height = size(frame1,2);

sz_img = 14; %square root of the number of images used
runs = 1; %how many times do you want to repeat the measurement?
steps = size(frame1,3); %number of datapoints

syms z
syms d

%disp_fun(z) = 400 - 0.02*(z - 108.7173)^2; %parabolic disp_fun
disp_fun(z) = 0.7*z; %linear disp_fun

RandomMatrix = zeros(sz_img,sz_img,4);
RPMatrix = zeros(sz_img);
sum_DOC = zeros(steps,runs);
dx_means = zeros(runs,1);
DOC = zeros(steps,1);

for i = 1:runs;
    RH_DOC; %giving DOC
    sum_DOC(:,i) = DOC; %storing all DOCs in matrix
    dx_means(i) = dx_mean; %storing all dx_means in matrix
end
DOC = mean(sum_DOC,2); %DOC is the mean of all our measurements

disp_inv = solve(disp_fun == d,z);
z_focus = zeros(length(disp_inv),1);

for k = 1:length(disp_inv)
    disp_root = disp_inv(k);
    disp_root(d) = disp_root;
    z_focus(k) = disp_root(dx_mean);
end

z_focus = double(mean(z_focus(:)));

z = transpose((1:steps) - z_focus); %setting z_focus to be 0

%W_z = DOC ./ (double(disp_fun(x)) + DOC);
W_z = DOC ./ (double(disp_fun(z+z_focus)) - dx_mean + DOC);

DOC_number = 4*sqrt(sum(W_z .* z.^2))

subplot(3,1,1);
plot(z,DOC);
subplot(3,1,2);
imagesc(1:length(CC_single),z,CC_single);
caxis auto;
colormap jet;
subplot(3,1,3);
plot(z,W_z);


