function varargout = rampOptimalUvarR(iters, stepScaling, scen, ustar)

global parameters

for i = 1:iters
  disp(['Current iteration is ', num2str(i), ', with R = ', num2str(parameters.R), '.']);
%   pause;
  [ustar, costStar] = rampOptimalU(scen, ustar);
  parameters.R = parameters.R*stepScaling;
  
end

varargout{1} = ustar;
varargout{2} = costStar;

end