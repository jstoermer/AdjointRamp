function outputState = forwardSimulation(scen, u)
%% outputState.density: (T + 1) x N
%% outputState.queue: (T + 1) x N
%% outputState.fluxIn/Out/Ramp: 1 x N

T = scen.T; N = scen.N;
density = zeros(T+1, N);
queue = zeros(T+1, N);
fluxIn = zeros(T,N);
fluxOut = zeros(T,N);
fluxRamp = zeros(T,N);
% initial conditions
density(1,:) = scen.IC.p0;
queue(1,:) = scen.IC.l0;

for loopT = 1:T % solve for time step loopT
    prevDensity = density(loopT,:);
    prevQueue = queue(loopT,:);
    inFluxes = zeros(1,N);
    outFluxes = zeros(1,N);
    rampFluxes = zeros(1,N);
    for loopLink = 1:N+1
        % solve for junction behind link loopLink
        if loopLink == 1 % start b.c.
            linkUp = [];
            densityUp = 0;
        else
            linkUp = scen.links(loopLink-1);
            densityUp = prevDensity(loopLink-1);
        end
        if loopLink == N+1 % end b.c.
            linkDown = [];
            densityDown = 0;
            queue = [];
            queueDemand = 0;
            uCurrent = 0;
            beta = 0;
            p = 0.0;
        else
            linkDown = scen.links(loopLink);
            densityDown = prevDensity(loopLink);
            queue = prevQueue(loopLink);
            queueDemand = scen.BC.D(loopT, loopLink);
            beta = scen.BC.beta(loopT, loopLink);
            uCurrent = u(loopT, loopLink);
            p = linkDown.p;
        end
        [fu, fd, fr] = solveJunction(linkUp, densityUp, linkDown, densityDown, queue, queueDemand, uCurrent, beta, p);
        if loopLink > 1
            inFluxes(loopLink-1) = fd;
            rampFluxes(loopLink - 1) = fr;
        end
        if loopLink < N + 1
            outFluxes(loopLink) = fu;
        end
    end
    
    newDensity = zeros(1, N);
    newQueue = zeros(1,N);
    for loopLink = 1:N
        fIn = inFluxes(loopLink); fOut = outFluxes(loopLink);
        fRampIn = scen.BC.D(loopT, loopLink); fRampOut = rampFluxes(loopLink);
        newDensity(loopLink) = prevDensity(loopLink) + scen.dt / scen.links(loopLink).L * (fIn - fOut);
        newQueue(loopLink) = prevQueue(loopLink) + scen.dt * (fRampIn - fRampOut);
    end
    fluxIn(loopT,:) = inFluxes';
    fluxOut(loopT,:) = outFluxes';
    fluxRamp(loopT,:) = rampFluxes';
    
    density(loopT+1,:) = newDensity;
    queue(loopT + 1,:) = newQueue;
end
outputState.density = density;
outputState.queue = queue;
outputState.fluxIn = fluxIn;
outputState.fluxOut = fluxOut;
outputState.fluxRamp = fluxRamp;

end

function [flowUp, flowDown, flowRamp] = solveJunction(linkUp, densityUp, linkDown, densityDown, queue, queueDemand, u, beta, p)

if isempty(linkUp) % start corner case
    demandUp = 0;
else
    demandUp = min(linkUp.v * densityUp, linkUp.fm); % upstream demand
end

if isempty(queue) % end corner case
    demandRamp = 0;
else
    if queue == 0 % check for empty queue
        demandRamp = min([queueDemand, linkDown.rmax, u]); % if empty kick out at demand rate
    else
        demandRamp = min([u,linkDown.rmax]); % in non-empty, kick out at max rate
    end
end

if isempty(linkDown) % end corner case
    supply = inf;
else
    rhoCrit = linkDown.v * linkDown.fm;
    rhoMax = linkDown.fm / linkDown.w + rhoCrit;
    supply = min([linkDown.fm, linkDown.w * (rhoMax - densityDown)]); % downstream supply
end

demand = demandUp * (1 - beta) + demandRamp;
if demand < supply % simple when demand constrained
    flowUp = demandUp;
    flowRamp = demandRamp;
else % supply constrained
    % blindly assume P intersects in feasible region
    flowRamp = supply / (1 + (1 - beta)* p);
    flowUp = (supply - flowRamp) / (1 - beta);
    if flowUp > demandUp % maxed out inlink
        flowUp = demandUp;
        flowRamp = supply - (1 - beta) * flowUp;
    elseif flowRamp > demandRamp % maxed out ramp
        flowRamp = demandRamp;
        flowUp = (supply - flowRamp) / (1 - beta);
    end
end
flowDown = demandUp * (1 - beta) + flowRamp;
end