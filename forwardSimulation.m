function [outputState u] = forwardSimulation(varargin)
%% outputState.density: (T + 1) x N
%% outputState.queue: (T + 1) x N
%% outputState.fluxIn/Out/Ramp: 1 x N
[scen, u] = scenUVarArgIn(varargin);

T = scen.T; N = scen.N;
density = zeros(T+1, N);
queueStore = zeros(T+1, N);
fluxIn = zeros(T,N);
fluxOut = zeros(T,N);
fluxRamp = zeros(T,N);
fluxOffRamp = zeros(T,N);
demandML = zeros(T,N);
supplyML = zeros(T,N);
demandRamp = zeros(T,N);
% initial conditions
density(1,:) = scen.IC.p0;
queueStore(1,:) = scen.IC.l0;

for loopT = 1:T % solve for time step loopT
    prevDensity = density(loopT,:);
    prevQueue = queueStore(loopT,:);
    inFluxes = zeros(1,N);
    outFluxes = zeros(1,N);
    rampFluxes = zeros(1,N);
    mlDemand =  zeros(1,N);
    mlSupply =  zeros(1,N);
    rampDemand =  zeros(1,N);
    offRampFlux = zeros(1,N);
    
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
            p = 1.0;
            rmax = 0.0;
        else
            linkDown = scen.links(loopLink);
            densityDown = prevDensity(loopLink);
            queue = prevQueue(loopLink);
            queueDemand = scen.BC.D(loopT, loopLink);
            beta = scen.BC.beta(loopT, loopLink);
            uCurrent = u(loopT, loopLink);
            p = linkDown.p;
            rmax = linkDown.rmax;
        end
        [fluxUSout, fluxDSin, fluxDSRamp, demandUS, demandR, supplyDS, fluxOff] = solveJunction(linkUp, densityUp, linkDown, densityDown, queue, queueDemand, uCurrent, beta, p, scen.dt, rmax);
        
        if loopLink > 1
            outFluxes(loopLink-1) = fluxUSout;
            mlDemand(loopLink - 1) = demandUS;
            offRampFluxes(loopLink - 1) = fluxOff;
        end
        if loopLink < N + 1
            rampFluxes(loopLink) = fluxDSRamp;
            rampDemand(loopLink) = demandR;
            inFluxes(loopLink) = fluxDSin;
            mlSupply(loopLink) = supplyDS;
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
    fluxIn(loopT,:) = inFluxes;
    fluxOut(loopT,:) = outFluxes;
    fluxRamp(loopT,:) = rampFluxes;
    demandML(loopT, :) = mlDemand;
    demandRamp(loopT, :) = rampDemand;
    supplyML(loopT, :) = mlSupply;
    fluxOffRamp(loopT, :) = offRampFluxes;
    
    density(loopT+1,:) = newDensity;
    queueStore(loopT + 1,:) = newQueue;
end
outputState.density = density;
outputState.queue = queueStore;
outputState.fluxIn = fluxIn;
outputState.fluxOut = fluxOut;
outputState.fluxRamp = fluxRamp;
outputState.fluxOffRamp = fluxOffRamp;
outputState.supply = supplyML;
outputState.demand = demandML;
outputState.rampDemand = demandRamp;
outputState.uPenalty = uPenalty(scen, queueStore, u);

end

function [fluxUSout, fluxDSin, fluxDSRamp, demandUS, demandRamp, supplyDS, offRampFlux] = solveJunction(linkUp, densityUp, linkDown, densityDown, queue, queueDemand, u, beta, p, dt, rmax)

p = 1 / (1 + p);

if isempty(linkUp) % start corner case
    demandUS = 0;
else
    demandUS = min(linkUp.v * densityUp, linkUp.fm); % upstream demand
end

demandRamp = min([queue / dt, rmax, u]);
% this approach isn't really working
%
%   if queue == 0 % check for empty queue
%     demandRamp = min([queueDemand, linkDown.rmax, u]); % if empty kick out at demand rate
%   else
%     demandRamp = min([queue / dt, u,linkDown.rmax]); % in non-empty, kick out at max rate
%   end

if isempty(linkDown) % end corner case
    supplyDS = inf;
else
    supplyDS = min([linkDown.fm, linkDown.w * (linkDown.pm - densityDown)]); % downstream supply
end

demand = demandUS * beta + demandRamp;
if demand < supplyDS % simple when demand constrained
    fluxUSout = demandUS;
    fluxDSRamp = demandRamp;
else % supply constrained
    % blindly assume P intersects in feasible region
    fluxDSRamp = (1 - p) * supplyDS;
    fluxUSout = p * supplyDS / beta;
    if fluxUSout > demandUS % maxed out inlink
        fluxUSout = demandUS;
        fluxDSRamp = supplyDS - beta * fluxUSout;
    elseif fluxDSRamp > demandRamp % maxed out ramp
        fluxDSRamp = demandRamp;
        fluxUSout = (supplyDS - fluxDSRamp) / beta;
    end
end
fluxDSin = fluxUSout * beta + fluxDSRamp;
offRampFlux = fluxUSout * (1 - beta);
if fluxDSin + offRampFlux ~= fluxUSout + fluxDSRamp
    return;
end
end