function Theta = dimensionlessTemperatureDifferenceCrank(dimensionlessRadius, FourierNumber, BiotNumber, rootValues)

% This function returns a 2-dimensional array of dimensionless temperature differences calculated with the analytical solution by CRANK. 
% Each column corresponds to a certain Fourier number given in the vector 'FourierNumber' and each row corresponds to a certain radial position 
% given in the vector 'radius'.

% The input is: 
% - dimensionlessRadius (vector of dimensionless radial positions within the sphere (made dimensionless with sphere diameter)) 
% - FourierNumber (vector of Fourier numbers) 
% - BiotNumber (single Biot number)
% - rootValues (vector of root values of the trancendental equation in the analytical solution by CRANK)


% Determine the size of the input vectors

numberOfRadiusValues = length(dimensionlessRadius);

numberOfFourierNumbers = length(FourierNumber);

numberOfRootValues = length(rootValues);


% Initialize the needed arrays

dimensionlessRadiusArray = zeros(numberOfRadiusValues, numberOfFourierNumbers, numberOfRootValues);

FourierNumberArray = zeros(numberOfRadiusValues, numberOfFourierNumbers, numberOfRootValues);

rootValuesArray = zeros(numberOfRadiusValues, numberOfFourierNumbers, numberOfRootValues);


dimensionlessRadiusInitialArray = zeros(numberOfRadiusValues,1,1);

FourierNumberInitialArray = zeros(1,numberOfFourierNumbers,1);

rootValuesInitialArray = zeros(1,1,numberOfRootValues);


% Fill the needed arrays

dimensionlessRadiusInitialArray(:,1,1) = dimensionlessRadius;

FourierNumberInitialArray(1,:,1) = FourierNumber;

rootValuesInitialArray(1,1,:) = rootValues;


dimensionlessRadiusArray = repmat(dimensionlessRadiusInitialArray, [1 numberOfFourierNumbers numberOfRootValues]);

FourierNumberArray = repmat(FourierNumberInitialArray, [numberOfRadiusValues 1 numberOfRootValues]);

rootValuesArray = repmat(rootValuesInitialArray, [numberOfRadiusValues numberOfFourierNumbers 1]);


% Calculate each series element for each given radius and each given Fourier number

resultsArray = (BiotNumber ./ dimensionlessRadiusArray) .* (exp(-FourierNumberArray .* rootValuesArray .^ 2) ./ (rootValuesArray .^ 2 + BiotNumber .* (BiotNumber - 1)) .* sin(rootValuesArray .* (2 .* dimensionlessRadiusArray)) ./ sin(rootValuesArray));


% Sum up all series elements for each given radius and each given Fourier number

Theta =  sum(resultsArray, 3);

end
