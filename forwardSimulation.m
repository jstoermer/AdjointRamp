function outputState = forwardSimulation(varargin)
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
    [fluxUSout, fluxDSin, fluxDSRamp, demandUS, demandR, supplyDS] = solveJunction(linkUp, densityUp, linkDown, densityDown, queue, queueDemand, uCurrent, beta, p, scen.dt);
    if loopLink > 1
      outFluxes(loopLink-1) = fluxUSout;
      mlDemand(loopLink - 1) = demandUS;
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
  
  
  density(loopT+1,:) = newDensity;
  queueStore(loopT + 1,:) = newQueue;
end
outputState.density = density;
outputState.queue = queueStore;
outputState.fluxIn = fluxIn;
outputState.fluxOut = fluxOut;
outputState.fluxRamp = fluxRamp;
outputState.supply = supplyML;
outputState.demand = demandML;
outputState.rampDemand = demandRamp;

end

function [fluxUSout, fluxDSin, fluxDSRamp, demandUS, demandRamp, supplyDS] = solveJunction(linkUp, densityUp, linkDown, densityDown, queue, queueDemand, u, beta, p, dt)

if isempty(linkUp) % start corner case
  demandUS = 0;
else
  demandUS = min(linkUp.v * densityUp, linkUp.fm); % upstream demand
end

if isempty(queue) % end corner case
  demandRamp = 0;
else
  if queue == 0 % check for empty queue
    demandRamp = min([queueDemand, linkDown.rmax, u]); % if empty kick out at demand rate
  else
    demandRamp = min([queue / dt, u,linkDown.rmax]); % in non-empty, kick out at max rate
  end
end

if isempty(linkDown) % end corner case
  supplyDS = inf;
else
  supplyDS = min([linkDown.fm, linkDown.w * (linkDown.pm - densityDown)]); % downstream supply
end

demand = demandUS * (1 - beta) + demandRamp;
if demand < supplyDS % simple when demand constrained
  fluxUSout = demandUS;
  fluxDSRamp = demandRamp;
else % supply constrained
  % blindly assume P intersects in feasible region
  fluxDSRamp = supplyDS / (1 + (1 - beta)* p);
  fluxUSout = (supplyDS - fluxDSRamp) / (1 - beta);
  if fluxUSout > demandUS % maxed out inlink
    fluxUSout = demandUS;
    fluxDSRamp = supplyDS - (1 - beta) * fluxUSout;
  elseif fluxDSRamp > demandRamp % maxed out ramp
    fluxDSRamp = demandRamp;
    fluxUSout = (supplyDS - fluxDSRamp) / (1 - beta);
  end
end
fluxDSin = demandUS * (1 - beta) + fluxDSRamp;
end