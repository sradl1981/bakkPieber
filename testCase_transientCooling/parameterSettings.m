% Settings for the evaluation of results

% Thermophysical properties

fluidHeatCapacity = 1000;

fluidDensity = 1;

solidHeatCapacity = 1000;

% Settings for the plot 

fontSizeAxis = 18;

fontSizeLabel = 25;

fontSizeText = 18;

markerSize = 9;

lineWidth = 2;

% Simulation parameters

sphereDiameter = 1;

flowVelocity = 1;

ReynoldsNumber = 10;

PrandtlNumber = 0.72;

densityRatioSolidToFluid = 2000; % 1500;

thermalConductivityRatioSolidToFluid = 5;

fluidInletTemperature = 300;

solidInitialTemperature = 400;

% Simulation results

steadyStateWallHeatFlux = 150645.418149;

% Settings for the evaluation

offsetTime = 30;

% Settings for the analytical solution

numberOfDiscreteRadialPositions = 50;

numberOfConsideredSeriesElements = 10;

% Calculate missing physical properties

fluidDynamicViscosity = sphereDiameter .* flowVelocity .* fluidDensity ./ ReynoldsNumber;

fluidThermalConductivity = fluidDynamicViscosity .* fluidHeatCapacity ./ PrandtlNumber;

solidDensity = densityRatioSolidToFluid .* fluidDensity;

solidThermalConductivity = thermalConductivityRatioSolidToFluid .* fluidThermalConductivity;

solidThermalDiffusivity = solidThermalConductivity ./ (solidHeatCapacity .* solidDensity);


% Calculate Nusselt number (Ranz-Marshall correlation)

NusseltNumberRanzMarshall = 2 + 0.60 .* ReynoldsNumber .^ (1/2) .* PrandtlNumber .^ (1/3);

% Calculate heat transfer coefficient 

heatTransferCoefficent = NusseltNumberRanzMarshall .* fluidThermalConductivity ./ sphereDiameter;

% Calculate Biot number (Note: The Biot number is calculated with the sphere radius while for the NUSSELT number the diameter is used!)

BiotNumberRanzMarshall = (NusseltNumberRanzMarshall .* fluidThermalConductivity) ./ (2 .* solidThermalConductivity); 
