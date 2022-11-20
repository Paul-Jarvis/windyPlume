% Script to calibrate image pixels to 
clear
close all

%% User Input Section
%%%%%%%%%%%%%%%% User Input Section %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%% Update Filepath %%%
% Filepath for which the functions folder and 'get_vent.kpg' file is located at
base_location = 'C:\Users\Paul Jarvis\Documents\Geneva\windCalib\windCalibration_Code\evieCode';
    
%%% Update pixels to claibrate %%%
% - can be vectors for multiple points to calibrate
readPoints = 'y'; %If 'y', read points from file (define dataFile, xCol and
                  %yCol). If 'n', define x_point, y_point.
dataFile = 'E:\Sabancaya_videos\IR\processed_data\20180808T1123\output\height.dat';
xCol = 3; %Column of data file containing x-coordinate of pixels
yCol = 8; %Column of data file containing y-coordinate of pixels
%x_point = [300 200]; % x coordinate of pixel to claibrate in image frame
%y_point = [300 200]; % y coordinate of pixel to claibrate in image frame

%%% Set filename of the image frame %%%
imageFrame = 'E:\Sabancaya_videos\IR\processed_data\20180808T1123\output\frames\1.png';
    
%%% Set weather data %%%
% Vector of year, month, day, hour, minute, second of time at which to 
% calibrate
b = [2018 08 08 16 26 00]; 

%Names of netCDF files containing wind and geopotential data. If files are
%the same, give same name for both.
windFilename = 'E:\Sabancaya_videos\weather\wind.nc'; 
geopotFilename = 'E:\Sabancaya_videos\weather\geopot.nc';

topPoint_Wind = 6900; % Height (in m a.s.l) which defines the upper limit 
                      %of height range to claulate the wind orientation over

%%% Set camera properties %%%
cam.pixel_width   = 640;    % Width in pixels of image frame
cam.pixel_height  = 480;    % Height in pixels of image frame
cam.FOV_H         = 24;     % Horizontal field of view of the camera
cam.z_cam         = 4957.9; % Height of the camera in m a.s.l
cam.oriCentreLine = 252;    % Orientation of the camera to the centre of 
                            %the image frame
cam.dist2plane    = 20600;  % Distance between the camera and the plane for 
                            %which points will be calibrated on

min_FOVH = 23.9625; % Minimum value of the horizontal field of view of the 
                    %camera (lower bound of the uncertinity)
max_FOVH = 24.0375; % Maximum value of the horizontal field of view of the 
                    %camera (upper bound of the uncertinity)
    
cam.incl = -100; % Inclination of the camera in degrees (put as -100 if 
                 %unknown)
    
%%% IF cam.incl in set to -100 i.e., unknown camera, inclination, update 
%   cam.dist2ref, vent.z_ref and vent.centre_pixel_height %%%
cam.dist2ref             = 20700; % Distance between the camera loction and 
                                  %a known point in the image frame
vent.z_ref               = 5900;  % Height in m a.s.l of a known point in 
                                  %the image frame (same at the point 
                                  %defined on line 29)
vent.centre_pixel_height = 447;   % Pixel value in the y direction of a 
                                  %known point in the image frame (same at 
                                  %the point defined on line 29)
    
%%% Set vent properties
ventKnown = 'y';    %If 'n', needs to be determined
x_pixel_vent = 548; %Pixel coordinates of vent. Don't need to be entered 
                    %if ventKnown = 'n'
y_pixel_vent = 447;
ventAlt = 5900;     %Altitude of vent in m above sea level
ventLat = -15.75;
ventLong = -71.75;
    
%%% Outfile
outFile = 'E:\Sabancaya_videos\IR\processed_data\20180808T1123\output\windCorr.dat';
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate other camera properties

    cam.FOV_V         = cam.FOV_H *(cam.pixel_height/cam.pixel_width);     % Calculate vertical field of view of the camera 
    
    cd functions
    if cam.incl == -100
        [incl]   = calcInclination(cam,vent);                              % Calculate inclination of the camera 
        cam.incl = incl
        
    end
 
    
%% Determine vent position
    cd .. 
    
    if ventKnown == 'n'
        A = imread(imageFrame);                                                % Load in imageFrame

        figure(1)                                                              % Display imageFrame
        axis on
        hold on
        imshow(A)
    
        [x_pixel_vent, y_pixel_vent] = ginput();                               % Manually select the position of the vent from which the plume origintes from
    end

    P_vent = [x_pixel_vent cam.pixel_height-y_pixel_vent];                 % Put pixel position of the vent into vector where position (1) is the x position and (2) is the y position. y position is adjusted as 0 starts at the top 
    
    cd functions
    
    %%% Calibrate vent position %%%
    [diff_z, diff_h] = calibrate(cam,P_vent);                              % Turn pixel location to diff_z (difference in calibrated point to camera in the vertical) and diff_h (difference in calibrated point to camera in the horizontal)
    
    vent_z = cam.z_cam + diff_z;                                           % Calulate absolute height (in m a.s.l) of the vent
    vent_x = diff_h;                                                       % Set vent_x to diff_h      
    
    cd ..
    
%% Load weather data %%%
    
    cd(base_location)
    cd functions
   
    [netCDF] = extract_weather(windFilename, b, geopotFilename, ...
        ventLat, ventLong);                              % Extract weather to a structure called netCDF

    %%% Get orientation  of the wind above the volcano %%%
    wind_v = interp1(netCDF.z,netCDF.v,vent_z:topPoint_Wind);              % Determine the wind velocity (v component) of the range defined at the base by the height of the vent and at the top by the topPoint_wind
    wind_u = interp1(netCDF.z,netCDF.u,vent_z:topPoint_Wind);              % Determine the wind velocity (u component) of the range defined at the base by the height of the vent and at the top by the topPoint_wind

    ori = atan2d(wind_v, wind_u);                                          % Calulate the wind oriention of the height rsnge of interest

    %%% Adjust angle of wind orientation to be with respect to the camera location %%%
    if ori <= 90
        Ori = 90 - ori;
    else
        Ori = 360-ori + 90;
    end

    %%% define Wind orientations to use in the calibration %%%
    min_Ori = min(Ori);                                                    % Determine min wind orientation of the range of the interest
    max_Ori = max(Ori);                                                    % Determine max wind orientation of the range of the interest
    Ori     = sum(Ori)/length(Ori);                                        % Determine average wind orientation of the range of the interest

    cd ..  
    
%% Read in points of interest
if readPoints == 'y'
    inData = readmatrix(dataFile);
    x_point = inData(:, xCol);
    y_point = cam.pixel_height - inData(:, yCol);
end

%%  Calibrate ponts of interest

    cd([base_location,'/functions'])
        
    %%%  Calibrate ponts of interest %%%
    % - height        == the height/s of the point/s of interest
    % - lowerUncert_z == the minimum height/s of the point/s of interest
    % - upperUncert_z == the maximum height/s of the point/s of interest
    % - dist          == the difference in the horizontal poisiton/s with respect the the camera of the point/s of interest
    % - lowerUncert_x == the minimum differne in the horizontal poisiton/s with respect the the camera of the point/s of interest
    % - upperUncert_x == the maximum differne in the horizontal poisiton/s with respect the the camera of the point/s of interest
    [upperUncert_x,lowerUncert_x,upperUncert_z,lowerUncert_z,dist,height] = getAllUncertinity(vent_x,vent_z,x_point,y_point,cam,Ori,P_vent,min_FOVH,max_FOVH,min_Ori,max_Ori);
     
%% Need to output data
writematrix(height, outFile);


