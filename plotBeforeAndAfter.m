function plotBeforeAndAfter(varargin)
fn = varargin{1};
if nargin == 2
    useBFGS = varargin{2};
else
    useBFGS = true;
end
s1 = loadScenario(fn);
plotForwardSim(s1);
s2 = loadScenario(fn);
optimalU = getOptimalMetering(s2,useBFGS);
s2.u = optimalU;
plotForwardSim(s2);
plotSimDifference(s1,s2);
end