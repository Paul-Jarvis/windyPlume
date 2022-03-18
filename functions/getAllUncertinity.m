function [upperUncert_x,lowerUncert_x,upperUncert_z,lowerUncert_z,dist,height] = getAllUncertinity(vent_x,vent_z,x_select,y_select,cam,Ori,P_vent,min_FOVH,max_FOVH,min_Ori,max_Ori)

%% Cal for av values - av FOV 18, av wind
        [dist,height] = Calibrate_allTogether(vent_x,vent_z,x_select,y_select,cam,Ori,P_vent);

%% Cal camera resolution
        % horizontal resolution
        [dist_a,height_a] = Calibrate_allTogether(vent_x,vent_z,x_select+1,y_select,cam,Ori,P_vent);
        [dist_b,height_b] = Calibrate_allTogether(vent_x,vent_z,x_select-1,y_select,cam,Ori,P_vent);
        
        x_cal_camRes_min = min(abs(dist - dist_a)/2, abs(dist - dist_b)/2);
        x_cal_camRes_max = max(abs(dist - dist_a)/2, abs(dist - dist_b)/2);
        
        % vertical resolution
        [dist_c,height_c] = Calibrate_allTogether(vent_x,vent_z,x_select,y_select+1,cam,Ori,P_vent);
        [dist_d,height_d] = Calibrate_allTogether(vent_x,vent_z,x_select,y_select-1,cam,Ori,P_vent);
        
        y_cal_camRes_min = min(abs(height - height_a)/2, abs(height - height_b)/2);
        y_cal_camRes_max = max(abs(height - height_a)/2, abs(height - height_b)/2);

            
        %% Calibrate upper point  - error from FOV
        
        % Cal for minFOV - min FOV 16 av wind
        cam_1 = cam;
        cam_1.FOV_H = min_FOVH;
        cam_1.FOV_V = cam_1.FOV_H *(cam_1.pixel_height/cam_1.pixel_width);
        [dist_1,height_1] = Calibrate_allTogether(vent_x,vent_z,x_select,y_select,cam_1,Ori,P_vent);
        
        % Cal for maxFOV - min FOV 20 av wind
        cam_2 = cam;
        cam_2.FOV_H = max_FOVH;
        cam_2.FOV_V = cam_2.FOV_H *(cam_2.pixel_height/cam_2.pixel_width);
        [dist_2,height_2] = Calibrate_allTogether(vent_x,vent_z,x_select,y_select,cam_2,Ori,P_vent);
        
        
        % Determine errors
        for k = 1:length(x_select)
            x_cal_FOV_min(k) = min([dist_1(k) dist_2(k)]);
            x_cal_FOV_max(k) = max([dist_1(k) dist_2(k)]);

            z_cal_FOV_min(k) = min([height_1(k) height_2(k)]);
            z_cal_FOV_max(k) = max([height_1(k) height_2(k)]);
        end
        
        x_cal_FOV_min = x_cal_FOV_min';
        x_cal_FOV_max = x_cal_FOV_max';
        
        z_cal_FOV_min = z_cal_FOV_min';
        z_cal_FOV_max = z_cal_FOV_max';
        

            
        %% Calibrate upper point  - error from wind
        
        % Cal for minOri - av FOV, min wind
        cam_3 = cam;
        [dist_3,height_3] = Calibrate_allTogether(vent_x,vent_z,x_select,y_select,cam_3,min_Ori,P_vent);
        
        % Cal for maxOri - av FOV, max wind
        cam_4 = cam;
        [dist_4,height_4] = Calibrate_allTogether(vent_x,vent_z,x_select,y_select,cam_4,max_Ori,P_vent);
        
        % Determine errors
        for k = 1:length(x_select)
            x_cal_wind_min(k) = min([dist_3(k) dist_4(k)]);
            x_cal_wind_max(k) = max([dist_3(k) dist_4(k)]);

            z_cal_wind_min(k) = min([height_3(k) height_4(k)]);
            z_cal_wind_max(k) = max([height_3(k) height_4(k)]);
        end
        
        x_cal_wind_min = x_cal_wind_min';
        x_cal_wind_max = x_cal_wind_max';
        
        z_cal_wind_min = z_cal_wind_min';
        z_cal_wind_max = z_cal_wind_max';
        
        
        upperUncert_x = x_cal_FOV_max;
        upperUncert_z = z_cal_FOV_max;
        
        lowerUncert_x = x_cal_FOV_min;
        lowerUncert_z = z_cal_FOV_min;
        
        
        

end

