function [dist,height] = Calibrate_allTogether(vent_x,vent_z,x_select,y_select,cam,Ori,P_vent)
% Function to calibrate the points of interest
% - dist          == the difference in the horizontal poisiton/s with respect the the camera of the point/s of interest
% - height        == the height/s of the point/s of interest (m a.s.l)


    %%% Create output arrays %%%
    dist   = zeros(size(x_select));
    height = zeros(size(x_select));
    
    
    %%% Loop throught each point to calibrate %%%
    for j = 1:length(x_select)
            %% Calibrate with geometrical calibration
        
            P_pixel = [x_select(j) y_select(j)];                           % Create vector of the x and y pixel coordinate of interest 
            
            [diff_z, diff_x] = calibrate(cam,P_pixel);                     % Run calibration function, diff_z and diff_h are the height and horizontal difference from the camera
                
           %% Tansform calibration due to wind 
            
            distanceFromVent_P1 = abs(diff_x - vent_x);                    % Work out the absolute horizontal distance from the vent and P1
            
            %%% Adjusted calibrated point because of wind %%%
            [x,y,z,lambda,w_tilde] = calibrateWind(Ori,cam,distanceFromVent_P1,P_vent,P_pixel);
            
            %%% Determine omega_prime %%%
            if cam.oriCentreLine + 180 < 360
                omega_prime =  cam.oriCentreLine + 180; 
            elseif cam.oriCentreLine + 180 > 360
                omega_prime =  cam.oriCentreLine - 180; 
            end
            
            %%% Calculate and assign diatnce between the vent and P2 %%%
            if P_pixel(1) >= P_vent(1)
                dist(j) = (((distanceFromVent_P1 + x)^2)  + (y^2))^0.5;
            elseif P_pixel(1) < P_vent(1)
                 dist(j) = -(((distanceFromVent_P1 + x)^2)  + (y^2))^0.5;
            end

             
            if w_tilde > 180 && w_tilde < 360
                dist(j) =  dist(j)*-1;
            end
            
            %%% Determine absolute height of calibrated point of interest %%%
            height(j) = cam.z_cam + diff_z + z;
    end


end

