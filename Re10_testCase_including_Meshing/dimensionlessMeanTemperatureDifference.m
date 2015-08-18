function ThetaMean = dimensionlessMeanTemperatureDifference(FourierNumber, BiotNumber, rootValues)


% Determine the size of the input vectors

numberOfFourierNumbers = length(FourierNumber);

numberOfRootValues = length(rootValues);


% Initialize the needed arrays

FourierNumberArray = zeros(numberOfFourierNumbers, numberOfRootValues);

rootValuesArray = zeros(numberOfFourierNumbers, numberOfRootValues);


FourierNumberInitialArray = zeros(numberOfFourierNumbers,1);

rootValuesInitialArray = zeros(1,numberOfRootValues);


% Fill the needed arrays

FourierNumberInitialArray(:,1) = FourierNumber;

rootValuesInitialArray(1,:) = rootValues;

FourierNumberArray = repmat(FourierNumberInitialArray, [1 numberOfRootValues]);

rootValuesArray = repmat(rootValuesInitialArray, [numberOfFourierNumbers 1]);


% Calculate each series element for each given radius and each given Fourier number

resultsArray = (6 .* BiotNumber .^ 2) .* exp(-FourierNumberArray .* rootValuesArray .^ 2) ./ (rootValuesArray .^ 2 .* (rootValuesArray .^ 2 + BiotNumber .* (BiotNumber - 1)));


% Sum up all series elements for each given radius and each given Fourier number

ThetaMean =  sum(resultsArray, 2);

end