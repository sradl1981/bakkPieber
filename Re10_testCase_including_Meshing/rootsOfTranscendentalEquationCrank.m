function results = rootsOfTranscendentalEquationCrank(BiotNumber, numberOfConsideredSeriesElements)

% This function calculates the root values of the transcendental equation in the analytical solution by CRANK.

% The input is:
% - BiotNumber (single Biot number)
% - numberOfConsideredSeriesElements (last considered element of the infinite series in the analytical solution by CRANK)


% Define the function whose roots correspond to the solutions of the transcendental equation

F = @(x) x .* cot(x) + BiotNumber - 1;


% Initilize results vector

results = zeros(length(numberOfConsideredSeriesElements));


% Calculate root values

for counter = 1 : numberOfConsideredSeriesElements

    initialPoint = (2 .* counter - 1) .* pi/2;
 
    results(counter) = fsolve(F, initialPoint);

end

end