% Routine to plot mean dimensionless temperature as function of Fourier number 
% (from simulation in comparison to the analytical solution)

clear

close all

clc

parameterSettings

% Settings for the evaluation

filePath = strcat('postProcessing/bedOfSpheres/averageSolidTemperature/', num2str(offsetTime), '/cellSource.dat');

% Settings for the plot

xLabelText = '$Fo$';

yLabelText = '$\bar{\Theta}$';

plotLegend = {'$Analytical solution$', '$Simulation$'};

simulationResultsLineStyle = '-';

simulationResultsLineColor = 'b';

correlationResultsLineStyle = '--';

correlationResultsLineColor = 'k';

% Read numeric data into matrix

solidTemperatureEvolution = dlmread(filePath,'',3,0);

time = solidTemperatureEvolution(:,1);

FourierNumber = ((time - offsetTime) .* solidThermalDiffusivity) ./ ((sphereDiameter ./ 2) .^ 2);

solidTemperature = solidTemperatureEvolution(:,3);

dimensionlessTemperature = 1 - (solidTemperature - fluidInletTemperature) ./ (solidInitialTemperature - fluidInletTemperature);

rootValues = rootsOfTranscendentalEquationCrank(BiotNumberRanzMarshall, numberOfConsideredSeriesElements);

ThetaMean = 1 - dimensionlessMeanTemperatureDifference(FourierNumber, BiotNumberRanzMarshall, rootValues);

% Plot the results

figure

hold all

plot(FourierNumber, ThetaMean, 'LineStyle', correlationResultsLineStyle, 'LineWidth', lineWidth, 'Color', correlationResultsLineColor)

plot(FourierNumber, dimensionlessTemperature, 'LineStyle', simulationResultsLineStyle,'LineWidth', lineWidth, 'Color', simulationResultsLineColor)

xlabel(xLabelText, 'interpreter', 'latex')

ylabel(yLabelText, 'interpreter', 'latex')

legend(plotLegend, 'interpreter', 'latex')

xAxisMin = 0;

xAxisMax = max(FourierNumber);

yAxisMin = 0;

yAxisMax = 1;

axis([xAxisMin xAxisMax yAxisMin yAxisMax])

makeXYPlotPretty


