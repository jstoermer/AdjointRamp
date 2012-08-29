function [stepSize] = findDecentStepSize(params)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

stepSize=params.alpha*ones(params.T*(params.N-1));

end

