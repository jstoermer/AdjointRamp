function varargout = rampOptimalUvarR(iters, stepScaling, scen, ustar)

global parameters

for i = 1:iters
  disp(['run ', num2str(i)]);
%   pause;
  [ustar, costStar] = rampOptimalU(scen, ustar);
  parameters.R = parameters.R*stepScaling;
  
end

varargout{1} = ustar;
varargout{2} = costStar;

end