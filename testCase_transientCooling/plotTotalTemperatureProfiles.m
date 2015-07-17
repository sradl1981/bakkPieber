% Routine to plot profiles of dimensionless temperature from simulation in comparison to the analytical solution for specified times during the cooling 
% process

clear

close all

clc

parameterSettings

% Settings for the evaluation

times = [130 530 1030]';

folderPathFluidUpstream = 'postProcessing/zTemperatureProfileInFluid/fluid/';

folderPathFluidDownstream = 'postProcessing/zTemperatureProfileInFluid/fluid/';

folderPathSphere = 'postProcessing/zTemperatureProfileInSolid/bedOfSpheres/';

fileNameFluidUpstream = 'positiveZLine_T.xy';

fileNameFluidDownstream = 'negativeZLine_T.xy';

fileNameSphere = 'zLine_T.xy';

% Settings for the plot

xAxisMin = -1;

xAxisMax = 1;

yAxisMin = 0;

yAxisMax = 1;

xLabelText = '$z^{\ast}$';

yLabelText = '$\Theta$';

plotLegend = {'$Analytical Solution$', '$Simulation$'};

fluidDomainMarker = '+';

solidDomainMarker = '+';

fluidDomainMarkerColor = 'b';

solidDomainMarkerColor = 'r';

fluidDomainLineStyle = ':';

solidDomainLineStyle = ':';

fluidDomainLineColor = fluidDomainMarkerColor;

solidDomainLineColor = solidDomainMarkerColor;

analyticalSolutionLineStyle = '-';

analyticalSolutionLineColor = 'k';

verticalLineStyle = '--';

verticalLineColor = 'k';

% Read in simulation results

for k = 1 : length(times)

    % Concatenate complete file path

    filePathFluidUpstream = strcat(folderPathFluidUpstream, num2str(times(k)),'/', fileNameFluidUpstream);
    
    filePathFluidDownstream = strcat(folderPathFluidDownstream, num2str(times(k)),'/', fileNameFluidDownstream);
    
    filePathSphere = strcat(folderPathSphere, num2str(times(k)),'/', fileNameSphere);

    temperatureProfileFluidUpstream(:,:,k) = dlmread(filePathFluidUpstream, '\t');

    temperatureProfileFluidDownstream(:,:,k) = dlmread(filePathFluidDownstream, '\t');

    temperatureProfileSphere(:,:,k) = dlmread(filePathSphere, '\t');
    
end


% Transform temperatures into dimensionless temperatures

dimensionlessTemperatureProfileFluidDownstream = (temperatureProfileFluidDownstream(:,2,:) - fluidInletTemperature) ./ (solidInitialTemperature - fluidInletTemperature);

dimensionlessTemperatureProfileFluidUpstream = (temperatureProfileFluidUpstream(:,2,:) - fluidInletTemperature) ./ (solidInitialTemperature - fluidInletTemperature);

dimensionlessTemperatureProfileSphere = (temperatureProfileSphere(:,2,:) - fluidInletTemperature) ./ (solidInitialTemperature - fluidInletTemperature);


% Calculate Fourier numbers corresponding to the specified times

FourierNumber = ((times - offsetTime) .* solidThermalDiffusivity) ./ ((sphereDiameter ./ 2) .^ 2);


% Set boundaries for dimensionless radius

smallNumber = 1e-6; 	

maximumDimensionlessRadius = 0.5;

% Create vector with dicrete dimensionless radial positions for the analytical solution

dimensionlessRadius = (linspace(maximumDimensionlessRadius, smallNumber, numberOfDiscreteRadialPositions))';

% Calculate roots of transcendental equation (needed for analytical solution)

rootValues = rootsOfTranscendentalEquationCrank(BiotNumberRanzMarshall, numberOfConsideredSeriesElements);

% Calculate analytical solution

Theta = dimensionlessTemperatureDifferenceCrank(dimensionlessRadius, FourierNumber, BiotNumberRanzMarshall, rootValues);

% Mirror results from anlytical solution (to obtain solution for the whole sphere diameter)

dimensionlessRadiusForPlot = vertcat(dimensionlessRadius, - flipud(dimensionlessRadius));

ThetaForPlot = vertcat(Theta, flipud(Theta));

% Plot the results

figure

xlabel(xLabelText, 'interpreter', 'latex')

ylabel(yLabelText, 'interpreter', 'latex')

axis([xAxisMin xAxisMax yAxisMin yAxisMax])

hold on

verticalLineYValues = linspace(yAxisMin, yAxisMax, 100);

plot(-maximumDimensionlessRadius * ones(length(verticalLineYValues),1), verticalLineYValues, 'LineStyle', verticalLineStyle, 'Color', verticalLineColor)

plot(maximumDimensionlessRadius * ones(length(verticalLineYValues),1), verticalLineYValues, 'LineStyle', verticalLineStyle, 'Color', verticalLineColor)

plot(zeros(length(verticalLineYValues),1), verticalLineYValues, 'LineStyle', verticalLineStyle, 'Color', verticalLineColor)



for k = 1 : length(times)

      plot(temperatureProfileFluidDownstream(:,1,k), dimensionlessTemperatureProfileFluidDownstream(:,k),'LineStyle', fluidDomainLineStyle, 'LineWidth', lineWidth, 'Color', fluidDomainLineColor, 'Marker', fluidDomainMarker, 'MarkerEdgeColor', fluidDomainMarkerColor, 'MarkerFaceColor',  fluidDomainMarkerColor)

      plot(temperatureProfileFluidUpstream(:,1,k), dimensionlessTemperatureProfileFluidUpstream(:,k),'LineStyle', fluidDomainLineStyle, 'LineWidth', lineWidth, 'Color', fluidDomainLineColor, 'Marker', fluidDomainMarker, 'MarkerEdgeColor', fluidDomainMarkerColor, 'MarkerFaceColor',  fluidDomainMarkerColor)

      plot(temperatureProfileSphere(:,1,k), dimensionlessTemperatureProfileSphere(:,k), 'LineStyle', solidDomainLineStyle, 'LineWidth', lineWidth, 'Color', solidDomainLineColor, 'Marker', solidDomainMarker, 'MarkerEdgeColor', solidDomainMarkerColor, 'MarkerFaceColor', solidDomainMarkerColor)

      plot(dimensionlessRadiusForPlot, ThetaForPlot(:,k), 'LineStyle', analyticalSolutionLineStyle, 'Color', analyticalSolutionLineColor, 'LineWidth', lineWidth)
      
      lineLabel = ['Fo = ' num2str(round(FourierNumber(k) .* 100) ./ 100)];
      
      text(-0.21, max(ThetaForPlot(:,k)) - 0.125, lineLabel, 'interpreter', 'latex', 'FontSize', fontSizeText); 
end

hold off

makeXYPlotPretty