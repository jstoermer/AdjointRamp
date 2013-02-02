function out = adjointStructure(data, state, cost, dhdx, djdx, dhdu, djdu)
clear statesStore;
global statesStore;
statesStore = false;

    function out = updateStates(u)
        statesStore = state(data, u);
        out = statesStore;
    end

    function out = getStates
        out = statesStore;
    end

    function [out, info] = gradient(u)
%       disp(1/9*(26*u - 12));
        states = getStates;
        dhdxVal = dhdx(data, states, u);
        djdxVal = djdx(data, states, u);
        dhduVal =  dhdu(data, states, u);
        djduVal = djdu(data, states, u);
        
        [out, lambda] = adjointGradient(dhdxVal, djdxVal, djduVal, dhduVal);
        if nargout == 2
            info.dhdx = dhdxVal;
            info.djdx = djdxVal;
            info.dhdu = dhduVal;
            info.djdu = djduVal;
            info.lambda = lambda;
        end
    end

    function out = objective(u)
        updateStates(u);
        states = getStates;
        out = cost(data, states, u);
    end

out.gradient = @gradient;
out.objective = @objective;
out.updateStates = @updateStates;
out.getStates = @getStates;
out.partials.dhdx = dhdx;
out.partials.djdx = djdx;
out.partials.dhdu = dhdu;
out.partials.djdu = djdu;
out.solveSystem = @adjointGradient;
end

function [out, lambda] = adjointGradient(dhdx, djdx, djdu, dhdu)
lambda = (dhdx' \ djdx');
out = (djdu - lambda'*dhdu)';
% disp('lambda');
% disp(lambda);
% disp('djdu');
% disp(djdu);
% disp('dhdu');
% disp(dhdu);
% disp('lambdadhdu');
% disp(lambda'*dhdu);
% disp('gradient');
% disp(out);
end
