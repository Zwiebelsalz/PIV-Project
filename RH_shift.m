function [ image ] = RH_shift( image, xshift, final_width )
%RH_shift Shifts row vector or image horizontally using positive
%x-shift

img_width = size(image,2);
img_height = size(image,1);

remainder = rem(xshift,1);
int_shift = xshift - remainder;

img1 = [zeros(img_height,1), remainder * image];
img2 = [(1-remainder) * image, zeros(img_height,1)];
img3 = img1+img2;

img3_width = size(img3,2);

image = [zeros(img_height,int_shift), img3, zeros(img_height, final_width - img3_width - int_shift)];

end

