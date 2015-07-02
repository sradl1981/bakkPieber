clear all

close all

clc

% Specify parameters

fluidFarFieldTemperature = 300;

sphereDiameter = 1;

flowVelocity = 1;

fluidThermalConductivity = 1000 .* 0.1 ./ 0.7;

solidThermalConductivity = fluidThermalConductivity .* 5;

solidHeatCapacity = 1000;

solidDensity = 1500;

% Read numeric data into matrix

% Specify file path (starting in the case directory)

filePath_volumeIntegratedSolidTemperature = 'postProcessing/bedOfSpheres/volumeIntegratedSolidTemperature/40/cellSource.dat';

filePath_surfaceAverageSolidTemperature = 'postProcessing/bedOfSpheres/averageSurfaceTemperature/40/faceSource.dat';

volumeIntegratedSolidTemperatureEvolution(:,:) = dlmread(filePath_volumeIntegratedSolidTemperature,'',3,0);

surfaceAverageSolidTemperatureEvolution(:,:) = dlmread(filePath_surfaceAverageSolidTemperature,'',3,0);

if sum(abs(volumeIntegratedSolidTemperatureEvolution(:,1) - surfaceAverageSolidTemperatureEvolution(:,1))) ~= 0

  msg = 'Times are not equal in result files!';

  error(msg)

end 

sphereSurfaceArea = sphereDiameter .^ 2 .* pi;

sphereVolume = 1/6 .* sphereDiameter .^ 3 .* pi;

relativeVolumeDeviation = abs(volumeIntegratedSolidTemperatureEvolution(1,2) - sphereVolume) ./ sphereVolume

relativeSurfaceAreaDeviation = abs(surfaceAverageSolidTemperatureEvolution(1,2) - sphereSurfaceArea) ./ sphereSurfaceArea

timeDifference = diff(volumeIntegratedSolidTemperatureEvolution(:,1));

volumeIntegratedSolidTemperatureDifference = diff(volumeIntegratedSolidTemperatureEvolution(:,3));

surfaceAverageSolidTemperature = surfaceAverageSolidTemperatureEvolution(1 : end - 1, 3);

% surfaceAverageSolidTemperature = surfaceAverageSolidTemperatureEvolution(1 : end - 1, 3) + 0.5 .* diff(surfaceAverageSolidTemperatureEvolution(:,3)); 

storedHeatDifference = solidDensity .* solidHeatCapacity .* volumeIntegratedSolidTemperatureDifference;

surfaceHeatFlux = - storedHeatDifference ./ timeDifference;

heatTransferCoefficient = surfaceHeatFlux ./ (sphereSurfaceArea .* (surfaceAverageSolidTemperature - fluidFarFieldTemperature));

NuNumber = heatTransferCoefficient .* sphereDiameter ./ fluidThermalConductivity;

time = volumeIntegratedSolidTemperatureEvolution(1 : end - 1, 1);

Fo = (time .* solidThermalConductivity ./ (solidHeatCapacity .* solidDensity)) / ((sphereDiameter/2) .^ 2);

% time = volumeAverageSolidTemperatureEvolution(1 : end - 1, 1) + 0.5 .* timeDifference;

plot(Fo, NuNumber)

axis([0 max(Fo) 2 4])

