% Routine to plot the Nusselt number as function of the Fourier number from
% simulation results

clear

close all

clc

% Load the required parameters

parameterSettings

% Specify evaluation type

NusseltEvaluation = 'surfaceAverageTemperatureBased';

% Specify path of the result files (starting in the case directory)

filePath_volumeAverageSolidTemperature = strcat('postProcessing/solidSphere/averageSolidTemperature/', num2str(offsetTime), '/cellSource.dat');

filePath_surfaceAverageSolidTemperature = strcat('postProcessing/solidSphere/averageSurfaceTemperatureSolid/', num2str(offsetTime),'/faceSource.dat');

filePath_volumeIntegratedSolidTemperature = strcat('postProcessing/solidSphere/volumeIntegratedSolidTemperature/', num2str(offsetTime),'/cellSource.dat');

% Settings for the plot

xLabelText = '$Fo$';

yLabelText = '$Nu$';

plotLegend = {'$Simulation (transient)$', '$Ranz-Marshall$', '$Simulation (steady)$'};

simulationResultsLineStyle = '-';

simulationResultsLineColor = 'b';

correlationResultsLineStyle = '--';

correlationResultsLineColor = 'k';

% Read in simulation result files

volumeAverageSolidTemperatureEvolution(:,:) = dlmread(filePath_volumeAverageSolidTemperature,'',3,0);

surfaceAverageSolidTemperatureEvolution(:,:) = dlmread(filePath_surfaceAverageSolidTemperature,'',3,0);

volumeIntegratedSolidTemperatureEvolution(:,:) = dlmread(filePath_volumeIntegratedSolidTemperature,'',3,0);

% Check if the times column in the result files is the same

if sum(abs(volumeIntegratedSolidTemperatureEvolution(:,1) - surfaceAverageSolidTemperatureEvolution(:,1))) ~= 0

  error('Times are not equal in result files!')

end 

% Calculate the theoretical sphere surface area and the relativ deviation
% compared to the discretized sphere

sphereSurfaceArea = sphereDiameter .^ 2 .* pi;

relativeSurfaceAreaDeviation = abs(surfaceAverageSolidTemperatureEvolution(1,2) - sphereSurfaceArea) ./ sphereSurfaceArea;

% Calculate the theoretical sphere volume and the relativ deviation
% compared to the discretized sphere

sphereVolume = 1/6 .* sphereDiameter .^ 3 .* pi;

relativeVolumeDeviation = abs(volumeAverageSolidTemperatureEvolution(1,2) - sphereVolume) ./ sphereVolume;

% Calculate the steady-state Nusselt number (from given steady-state wall
% heat flux)

steadyStateNusseltNumber = (steadyStateWallHeatFlux ./ (sphereSurfaceArea .* (solidInitialTemperature - fluidInletTemperature))) .* sphereDiameter ./ fluidThermalConductivity;

% Create vector with times 

times = volumeAverageSolidTemperatureEvolution(:,1) - offsetTime;

% Create vector with time differences

timeDifference = diff(times);

% Create vector with differences in volume averaged sphere temperature

volumeAverageSolidTemperatureDifference = diff(volumeAverageSolidTemperatureEvolution(:,3));

% Create vector with differences in volume integrated sphere temperature

volumeIntegratedSolidTemperatureDifference = diff(volumeIntegratedSolidTemperatureEvolution(:,3));

% Create vector with surface averaged sphere temperature in the middle of
% each time interval (using linear interpolation in each time interval)

surfaceAverageSolidTemperature = surfaceAverageSolidTemperatureEvolution(1 : end - 1, 3) + 0.5 .* diff(surfaceAverageSolidTemperatureEvolution(:,3)); 

% Create vector with volume averaged sphere temperature in the middle of
% each time interval (using linear interpolation in each time interval)

volumeAverageSolidTemperature = volumeAverageSolidTemperatureEvolution(1 : end - 1, 3) + 0.5 .* diff(volumeAverageSolidTemperatureEvolution(:,3)); 

% Calculate transfered amount of heat for each time intervall
storedHeatDifference = solidDensity .* solidHeatCapacity .* volumeIntegratedSolidTemperatureDifference;

% Calculate heat flux across the sphere surface for each time interval

surfaceHeatFlux = - storedHeatDifference ./ timeDifference;

% Calculate heat transfer coefficient for each time interval

    
if strcmp(NusseltEvaluation, 'surfaceAverageTemperatureBased')

        heatTransferCoefficient = surfaceHeatFlux ./ (sphereSurfaceArea .* (surfaceAverageSolidTemperature - fluidInletTemperature));
        
elseif strcmp(NusseltEvaluation, 'volumeAverageTemperatureBased')
        
        heatTransferCoefficient = surfaceHeatFlux ./ (sphereSurfaceArea .* (volumeAverageSolidTemperature - fluidInletTemperature));
    
else
        
        error('Please choose a valid method for evaluating the Nusselt number!')
        
end

% Calculate Nusselt number for each time interval

NusseltNumber = heatTransferCoefficient .* sphereDiameter ./ fluidThermalConductivity;

% Create vector with time instances in the middle of each time interval
% (using linear interpolation)

time = times(1 : end - 1) + 0.5 .* timeDifference;

% Calculate the corresponding Fourier numbers

FourierNumber = (time .* solidThermalDiffusivity) ./ ((sphereDiameter ./ 2) .^ 2);

% Plot the Nusselt number evolution

figure

hold all

plot(FourierNumber, NusseltNumber, 'LineStyle', simulationResultsLineStyle, 'LineWidth', lineWidth, 'Color', simulationResultsLineColor);

% Determine axis limits

xAxisMin = 0;

xAxisMax = 1;

yAxisMin = 0; %min(NusseltNumber) - 0.5;

yAxisMax = 8; %max(NusseltNumber) + 0.5;

% Plot Nusselt number from correlation

xValuesNusseltFromCorrelation = linspace(xAxisMin, xAxisMax, 100);

yValuesNusseltFromCorrelation = NusseltNumberRanzMarshall .* ones(length(xValuesNusseltFromCorrelation),1);

plot(xValuesNusseltFromCorrelation, yValuesNusseltFromCorrelation, 'LineStyle', correlationResultsLineStyle, 'Color', correlationResultsLineColor);

% Plot steady-state Nusselt number

plot(0, steadyStateNusseltNumber, 'LineStyle', 'none', 'Marker', 'o', 'MarkerFacecolor', 'w', 'MarkerEdgeColor', 'r', 'MarkerSize', 5);

% Format the plot

set(0, 'defaultTextInterpreter', 'latex'); 

box on

xlabel(xLabelText,'interpreter','latex')

ylabel(yLabelText,'interpreter','latex')

axis([xAxisMin xAxisMax  yAxisMin yAxisMax]);

leg = legend(plotLegend, 'interpreter', 'latex');

legend('boxoff')

set(leg,'location','SouthEast'); 

makeXYPlotPretty

