load('/Users/Zwiebelsalz/Documents/PIV-Project/Bf_images/frame1.mat');
load('/Users/Zwiebelsalz/Documents/PIV-Project/Bf_images/frame2.mat');

frame1 = frame1(:,:,59:158); %choosing a square number of images
frame2 = frame2(:,:,59:158); %with the focal plane at the center

img_width = size(frame1,1);
img_height = size(frame1,2);

sz_img = 10; %square root of the number of images used
steps = size(frame1,3);     
max_shift = 140; %maximum peak shift
min_shift = 140; %minimum peak shift
skip = 1;
runs = round((1+max_shift-min_shift)/skip);

radius = 25;
d = 2*radius;

syms z

RandomMatrix = zeros(sz_img,sz_img,4); %initialising
RPMatrix = zeros(sz_img);
velocities = zeros(steps,runs);
DOC = zeros(steps,1);

max_disp = round(max_shift/img_width) + 3;

CC_row = zeros(steps,max_shift + 2*img_width);

n = 0;
for m = min_shift:skip:max_shift
        n = n+1;
        wb = waitbar(0,strcat('please wait...',sprintf('step %03d of %03d.',n,runs)));
        
        disp_fun(z) = -4*m/d^2 * (z)^2 + 4*m/d * (z);
        
        for i = 1:steps;
%        shift = 0.5 * i / steps;
         shift = 0.5 * i;
%         disp_poly = polyfit([0+shift, 0.25+shift, 0.5+shift], [0, 1, 0], 2);
%         %shifting the displacement function to simulate tube flow
%         disp_poly = m .* ( (1/steps).^[length(disp_poly)-1:-1:0] ) .* disp_poly;
%         %max displacement is m, range of displacement is number of steps


        CC_singles = zeros(steps,2*img_width - 1);
        CC_singles_shift = zeros(steps,max_shift + 2*img_width);
        
        for k = 1:steps
            %displacement = polyval(disp_poly, k);
            displacement = double(disp_fun(k - shift));
            
            if displacement > 0;
                image1 = frame1(:,:,k);
                image2 = frame2(:,:,k);
    
                [~, CC_singles(k,:)] = RH_offset(image1, image2);
                
                CC_singles_shft(k,:) = RH_shift(CC_singles(k,:),displacement,max_shift + 2*img_width);
                
            else
                CC_singles_shft(k,:) = 0;
            end
        end
        
        CC_row(i,:) = sum(CC_singles_shft);
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