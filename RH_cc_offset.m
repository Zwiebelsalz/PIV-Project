function [ corr_offset ] = RH_cc_offset( cc_row , frame1_dim)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    [~, xpeak] = max(cc_row);
    
    if xpeak > 1
        points = [cc_row(xpeak-1), cc_row(xpeak), cc_row(xpeak+1)];
        [parabola] = polyfit(xpeak-1:xpeak+1,points,2);

        diff_parabola = polyder(parabola); %differentiating

        precise_xpeak = roots(diff_parabola);

        corr_offset = (precise_xpeak-frame1_dim);
    else
        corr_offset = 0;
    end
end

