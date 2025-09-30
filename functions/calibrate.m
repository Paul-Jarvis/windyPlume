function [diff_z, diff_h] = calibrate(cam,P_pixel)

%% Camera details
    incl = cam.incl;
    dist_diff = cam.dist2plane;                                                          % distance between camera and reference point in m's asl
    pixel_height = cam.pixel_height;
    pixel_width = cam.pixel_width;
    FOV_V = cam.FOV_V;
    FOV_H = cam.FOV_H;
    
    i = P_pixel(2);
    j = P_pixel(1);
    
    delta_theta_z = FOV_V / pixel_height;
    delta_theta_h = FOV_H / pixel_width;
    
    incl_h = 0;
    
%% Calibrate for height
    
    diff_z = (dist_diff/2)*(tand(incl - (FOV_V/2) + (i-1)*delta_theta_z) + tand(incl - (FOV_V/2) + (i*delta_theta_z)));
    
%% Calibrate for length
    %diff_h = (dist_diff/2)*(tand(incl_h - (FOV_H/2) + (j-1)*delta_theta_h) + tand(incl_h - (FOV_H/2) + (j*delta_theta_h)));
    diff_h = (dist_diff/2)*(tand(-(FOV_H/2) + (j-1)*delta_theta_h) + tand(-(FOV_H/2) + (j*delta_theta_h)));
    
    
end

