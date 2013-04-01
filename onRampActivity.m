function onRampAct = onRampActivity(outputState, onRampID, u)
% Calculates the on-ramp "activity", which is given by the following:
% max(min(queue, rmax) - u, 0).

onRampAct = max(min(outputState.queue(:, onRampID), scen.links(onRampID).rmax) - [0; u(:, onRampID)], 0);

end 