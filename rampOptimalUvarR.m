function ustar = rampOptimalUvarR(iters, stepScaling, scen, ustar)

global parameters

for i = 1:iters
  disp(['run ', num2str(i)]);
%   pause;
  ustar = rampOptimalU(scen, ustar);
  parameters.R = parameters.R*stepScaling;
end

end