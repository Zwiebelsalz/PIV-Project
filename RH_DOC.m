clear DOC
clear W_z

max_disp = max(double(disp_fun(1:steps)));
max_disp = round(max_disp/img_width) + 3;

CC_single = zeros(steps, max_disp * img_width - 1);

wb = waitbar(0,strcat('please wait... ',sprintf('step %03d of %03d',i,runs)));

for k = 1:steps
    %displacement = polyval(disp_poly, k);
    displacement = double(disp_fun(k));
    
    image1 = frame1(:,:,k);
    image2 = RH_shift(frame2(:,:,k), displacement, (max_disp - 1) * img_width);
    
    [~, CC_single(k,:)] = RH_offset(image1, image2);
    
    
    waitbar(k/steps);
end

CC_row = sum(CC_single);
dx_mean = RH_cc_offset(CC_row, img_width);


for k = 1:steps
    CC_row = sum(CC_single(1:steps~=k,:)); % excluding layer k
    DOC(k) = RH_cc_offset(CC_row, img_width);
end
DOC = dx_mean - DOC;

close(wb);
