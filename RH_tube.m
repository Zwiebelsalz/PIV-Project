load('/Volumes/TRANSCEND/Uni/MATLAB/br_split_mat2/frame1.mat');
load('/Volumes/TRANSCEND/Uni/MATLAB/br_split_mat2/frame2.mat');
%load('D:\Uni\MATLAB\PIV Stuff\br_split_mat2\frame1.mat');
%load('D:\Uni\MATLAB\PIV Stuff\br_split_mat2\frame2.mat');

frame1 = frame1(:,:,59:158); %choosing a square number of images
frame2 = frame2(:,:,59:158); %with the focal plane at the center

img_width = size(frame1,1);
img_height = size(frame1,2);

sz_img = 10; %square root of the number of images used
steps = size(frame1,3);     
max_shift = 3; %maximum peak shift
min_shift = 1; %minimum peak shift
skip = 1;

RandomMatrix = zeros(sz_img,sz_img,4); %initialising
RPMatrix = zeros(sz_img);
velocities = zeros(steps,round(max_shift/skip));
DOC = zeros(steps,1);

max_disp = round(max_shift/img_width) + 3;

CC_row = zeros(steps,max_disp * img_width - 1);

n = 0;
for m = min_shift:skip:max_shift
        n = n+1;
        wb = waitbar(0,strcat('please wait...',sprintf('step %03d of %03d.',n,round(max_shift/skip))));
        
        for i = 1:steps;
        shift = 0.5 * i / steps;
        disp_poly = polyfit([0+shift, 0.25+shift, 0.5+shift], [0, 1, 0], 2);
        %shifting the displacement function to simulate tube flow
        disp_poly = m .* ( (1/steps).^[length(disp_poly)-1:-1:0] ) .* disp_poly;
        %max displacement is m, range of displacement is number of steps

        CC_singles = zeros(steps,max_disp * img_width - 1);
        
        for k = 1:steps
            displacement = polyval(disp_poly, k);
            if displacement > 0;
                image1 = frame1(:,:,k);
                image2 = RH_shift(frame2(:,:,k), displacement, (max_disp - 1) * img_width);
    
                [~, CC_singles(k,:)] = RH_offset(image1, image2);
            else
                CC_singles(k,:) = 0;
            end
        end
        
        CC_row(i,:) = sum(CC_singles);
        velocities(i,n) = RH_cc_offset(CC_row(i,:), img_width);

        waitbar(i/steps);
        end
        close(wb);
end

subplot(2,1,1);
plot(velocities,'.');

[~, max_i] = max(transpose(CC_row));

for k = 1:steps
CC_row(k, max_i(k)) = max(CC_row(:));
end

subplot(2,1,2);
imshow(CC_row(:,img_width:img_width+1.5*max_shift))
caxis auto
colormap jet