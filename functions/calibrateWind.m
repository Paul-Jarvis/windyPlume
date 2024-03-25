function[x,y,z,lambda,w_tilde] = calibrateWind(Ori,cam,distanceFromVent,P_vent,P_pixel)

%% Camera details

    incl = cam.incl;
    FOV_V = cam.FOV_V;
    FOV_H = cam.FOV_H;
    pixel_height = cam.pixel_height;
    pixel_width = cam.pixel_width;
    oriCentreLine = cam.oriCentreLine;
    
%% Calculate lambda

    if Ori < 180
        w_prime = Ori;
    elseif Ori >= 180
        w_prime = Ori - 180;
    else
        disp('Error with setting w prime')
    end
    
    if 0 <= oriCentreLine && oriCentreLine < 90
        I = oriCentreLine + 90;
    elseif 90 < oriCentreLine && oriCentreLine <= 270
        I = oriCentreLine - 90;
    elseif 270 < oriCentreLine && oriCentreLine < 360
        I = oriCentreLine - 270;
    else
        disp('Error with setting wind orientation')
    end
         
    if abs(I - w_prime) < 90
        lambda = abs(I - w_prime);
    elseif abs(I - w_prime) > 90
        lambda = 180 - abs(I - w_prime);
    else
        disp('Error with setting lambda')
    end
    
    if (Ori - oriCentreLine) > 0     
        w_tilde = Ori - oriCentreLine;
    elseif (Ori - oriCentreLine) < 0   
        w_tilde = Ori - oriCentreLine + 360;
    else
        disp('Error with setting w tilde')
    end
    
%% Calculate changes

    alpha = P_pixel(1)*(FOV_H/pixel_width);
    b = distanceFromVent;                                    %distance between vent and point
    chi = (P_pixel(2) * FOV_V)/pixel_height;
    di = incl - (FOV_V/2) + chi;
            
    if (90 < w_tilde) && (w_tilde < 180) || (270 <= w_tilde) && (w_tilde < 360)
    
        h = (b * sind(lambda)) / cosd(alpha - (FOV_H/2) - lambda);
        
        if P_pixel(1) >= P_vent(1)
            x = -h * sind((FOV_H/2) - alpha);
            y = -h * cosd((FOV_H/2) - alpha);
            z = y * tand(di);
        elseif P_pixel(1) < P_vent(1)
            x = h * sind((FOV_H/2) - alpha);
            y = h * cosd((FOV_H/2) - alpha);
            z = y * tand(di);
        end

    elseif (0 < w_tilde) && (w_tilde <= 90) || (180 < w_tilde) && (w_tilde < 270)
        
        h = (b * sind(lambda)) / cosd(alpha - (FOV_H/2) + lambda);
        if P_pixel(1) >= P_vent(1)
            x = -h * sind((FOV_H/2) - alpha);
            y = h * cosd((FOV_H/2) - alpha);
            z = y * tand(di);
        elseif P_pixel(1) < P_vent(1)
            x = h * sind((FOV_H/2) - alpha);
            y = -h * cosd((FOV_H/2) - alpha);
            z = y * tand(di);
        end
    else
        disp('Error with choosing based on relationship between wind orientation and centreline orientation')
    end
 

end

