function [ corr_offset, cc_row ] = RH_offset( frame1, frame2 )
%RH_offset calaculates the offset of two images using cross correlation.
%   RH_offset calaculates the offset of two images using cross correlation

if max(frame2(:))>0
    cc = xcorr2_fft(frame2,frame1);

    [~, imax] = max(cc(:));
    [ypeak, xpeak] = ind2sub(size(cc),imax(1));

    cc_row = cc(ypeak,:); %because we are only interested in x-shift

    corr_offset = RH_cc_offset(cc_row,size(frame1,2));
else
    corr_offset = 0;
    cc_row = zeros(1,size(frame1,2)+size(frame2,2)-1);
end

end

