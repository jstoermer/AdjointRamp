function [u, outputState] = optimalU(varargin)
scen = loadScenario(varargin{1});
try
    u = varargin{2};
catch e
    disp(e);
    u = chooseInitialU(scen);
end

while true
    outputState = forwardSimulation(scen, u);
    gradient = gradientRampControl(scen, outputState, u);
    nextU = nextRampControl(scen, gradient, u);
    if stopIterating(scen, u, nextU)
        u = nextU;
        return;
    end
    u = nextU;
end
end




function gradient = gradientRampControl(scen, outputState, u)
end

function nextU = nextRampControl(scen, gradient, u)
end

function stop = stopIterating(scen, u, nextU)
end