function [incl] = calcInclination(cam,vent)

%% Assign camera details
    z_cam        = cam.z_cam;                                              % Height of the camera in m a.s.l
    dist_diff    = cam.dist2ref;                                           % Distance between the camera loction and a known point in the image frame
    pixel_height = cam.pixel_height;                                       % Height in pixels of image frame
    FOV_V        = cam.FOV_V;                                              % Calculate vertical field of view of the camera
    
    z_ref = vent.z_ref;                                                    % Height in m a.s.l of a known point in the image frame
    
%% Calculate Inclination

    phii = atand((z_ref-z_cam)/(dist_diff));                               % Define angle between
    
    z_refPixel = pixel_height - vent.centre_pixel_height;

    %%COMMENTED OUT LINE IS INCORRECT EXPRESSION, EQUATION 14 IN SNEE ET
    %%AL. (2023)
    %incl = phii + atand((1 - ((2*z_refPixel)/pixel_height))*tand(FOV_V/2));
    incl = FOV_V * (0.5 - z_refPixel / pixel_height) + phii;
end

