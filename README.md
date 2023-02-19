# windyPlume
Repository containing Matlab code that can be used to calibrate images of
wind-affected volcanic plumes. For a full description of how the software works
see a) comments in code and b) manuscript by Snee et al. (in prep)

## Contents

Script_2_Calibrate.m - This is the primary script, to be ran by the user.
                       Variables in the User-Input section are to be edited by
		       the user.

functions/calibrate.m - Function that performs the geometric calibration based on
                        Bombrun et al. (2018)

functions/Calibrate_allTogether.m - Function that performs the calibration

functions/calcInclination.m - Function to estimate the camera inclination (if it
                              is not known)

functions/calibrateWind.m - Function to perform the wind correction to the
                            calibration

functions/extract_weather.m - Function to extract weather data from netCDF file

functions/getAllUncertainty.m - Function called by Script_2_Calibrate.m -
                                Performs the calibration for different values of
				the input parameters corresponding to the ranges
				of their uncertainties.

SabancayaExample.m - Version of Script_2_Calibrate used to analyse eruption of
                     Sabancaya volcano on 31/07/2018, as presented in Snee et
		     al. (in prep).

exampleData - Directory containing example data pertaining to the 31/07/2018
              eruption of Sabancaya presented in Snee et al. (in prep).

exampleData/Sabancaya2018/geopot.nc - NetCDF file containing geopotential data
                                      above Sabancaya volcano on 31/07/2028,
				      used for the wind calibration. Data
				      downloaded from
				      https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-pressure-levels?tab=overview

exampleData/Sabancaya2018/plume.jpg - Example of frame from video of eruption.
                                      The full video can be found as Supporting
				      Information to Snee et al. (in prep).

exampleData/Sabancaya2018/plumeParameters.csv - Datafile including the pixel
                                                coordinates of the top of the
						plume in each frame from the
						video of the eruption. File
						created using the PlumeTraP
						software (Simionato et al.,
						2022)

exampleData/Sabancaya2018/windHeight.csv - Output from windyPlume showing the
                                           plume height (a.s.l) (column 2) as a
					   function of time (s) (column 1)

exampleData/Sabancaya/wind.nc - NetCDF file containing geopotential data above
                                Sabancaya volcano on 31/07/2028, used for the
				wind calibration. Data downloaded from
				https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-pressure-levels?tab=overview
				
## Pre-requisites

windyPlume has been tested on 2019 and later versions of Matlab. It may work for
earlier versions but has not been tested.

## Issues

Reporting of issues and/or contacting the authors can be achieved through the
GitHub repository for the code:
https://github.com/Paul-Jarvis/windyPlume/issues. To report an issue, click on
the "New issue" icon and leaving a comment. If reporting a bug or unexpected
behaviour, please provide as much detail as possible, inlcuding a minimal
example. The authors will make a best endeavour to respond in a reasonable time

## Contributing to the software

Users are welcome to edit the software for their own purposes and are welcome to
contact the authors during this process (see "Issues" above). We invite such
users to contribute their edits to our code. The easiest way to achieve this is
probably to:

1. Create a fork of the repository. To do this, go to the code repository at
https://github.com/Paul-Jarvis/windyPlume and click on the "Fork" icon in the
top right. More information about how to create a fork and work with the
subsequent copy of the repository can be found at
https://docs.github.com/en/get-started/quickstart/fork-a-repo.

2. Work with your fork to make the desired changes.

3. Submit a pull request, proposing your changes, at
https://github.com/Paul-Jarvis/windyPlume/pulls by clicking on the "New pull
request" icon. More information on pull requests can be found at
https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request-from-a-fork.

## Authors

Eveanjelene Snee

Paul A. Jarvis

## References

Simionato, R., Jarvis, P. A., Rossi, E. & Bonadonna, C. (2022). PlumeTraP: A New
MATLAB-Based Algorithm to Detect and Parameterize Volcanic Plumes from Visible
Wavelength Images. Rem. Sens., 14(7), 1766. https://doi.org/10.3390/rs14071766

Snee, E., Jarvis, P. A., Simionato, R., Scollo, S., Prestifilippo, M., Degruyter,
W. & Bonadonna, C. (in prep). Image analysis of volcanic plumes: A simple
calibration tool to correct for the effect of wind. Submitted to Volcanica.