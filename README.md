# windyPlume
Repository containing Matlab code that can be used to calibrate images of wind-affected volcanic plumes. For a full description of how the software works see a) comments in code and b) manuscript by Snee et al. 

Contents:

Script_2_Calibrate.m - This is the primary script, to be ran by the user. Variables in the User-Input section are to be edited by the user.

functions/calibrate.m - Function that performs the geometric calibration based on Bombrun et al. (2018)

functions/Calibrate_allTogether.m - Function that performs the calibration

functions/calcInclination.m - Function to estimate the camera inclination (if it is not known)

functions/calibrateWind.m - Function to perform the wind correction to the calibration

functions/extract_weather.m - Function to extract weather data from netCDF files.

functions/getAllUncertainty.m - Function called by Script_2_Calibrate.m - Performs the calibration for different values of the input parameters corresponding to the ranges of their uncertainties.
