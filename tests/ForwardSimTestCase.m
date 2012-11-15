classdef ForwardSimTestCase < TestCase
  
  properties
    scen;
    states;
    u;
  end

  methods
    
    function out = rep(varargin)
      self = varargin{1};
      rowvec = varargin{2};
      if nargin == 3
        t = varargin{3};
      else
        t = self.scen.T;
      end
      out = repmat(rowvec, t, 1);
    end
    
    function self = ForwardSimTestCase(name)
      self = self@TestCase(name);
    end
    
    
    function setUp(self)
      loadParameters;
      self.scen = loadScenario('../networks/samitha1onrampcomplex.json');
      self.u = ones(self.scen.T, self.scen.N);
      self.states = forwardSimulation(self.scen);
    end
    
    function testMassBalance(self)
      ls = [self.scen.links.L]';
      carsIn = sum(sum(self.scen.BC.D))*self.scen.dt +...
        sum(self.scen.IC.l0) +...
        sum(self.scen.IC.p0*ls);
      carsLeft = self.states.density(end,:)*ls + sum(self.states.queue(end,:));
      carsOut = sum(sum(self.states.fluxOffRamp));
      assertElementsAlmostEqual(carsLeft, carsIn - carsOut);
    end
    
    function testFluxConsistency(self)
      os = self.states;
      fout = [zeros(size(os.fluxOut,1),1) os.fluxOut];
      foff = [zeros(size(os.fluxOffRamp,1),1) os.fluxOffRamp];
      fin = [os.fluxIn zeros(size(os.fluxOut,1),1)];
      framp = [os.fluxRamp zeros(size(os.fluxOut,1),1)];
      assertVectorsAlmostEqual(fout + framp,  fin + foff);
    end
    
    function testQueueBalance(self)
      os = self.states; scen = self.scen;
      l = os.queue;
      
      nextQueue = l(2:end, :); 
      prevQueue = l(1:end-1, :);
      carsIn = scen.BC.D .* scen.dt;
      carsOut = os.fluxRamp .* scen.dt;
      
      assertVectorsAlmostEqual(nextQueue, prevQueue + carsIn - carsOut);
    end
    
    function testLinkBalance(self)
      os = self.states; scen = self.scen;
      rho = os.density;
      L = [scen.links.L];
      
      nextCars = rho(2:end, :).*self.rep(L);
      prevCars = rho(1:end-1, :).*self.rep(L);
      carsIn = os.fluxIn .* scen.dt;
      carsOut = os.fluxOut .* scen.dt;
      
      assertVectorsAlmostEqual(nextCars, prevCars + carsIn - carsOut);
    end
    
    function testDemandSupply(self)
      os = self.states; scen = self.scen;
      rho = os.density(1:end-1,:);
      l = os.queue(1:end-1,:);
      L = self.rep([scen.links.L]);
      v = self.rep([scen.links.v]);
      w = self.rep([scen.links.w]);
      fm = self.rep([scen.links.fm]);
      pm = self.rep([scen.links.pm]);
      rmax = self.rep([scen.links.rmax]);
      

      assertVectorsAlmostEqual(os.demand,...
        min(rho.*v, fm));
      
      assertVectorsAlmostEqual(os.supply,...
        min(w.*(pm - rho), fm));
      
      assertVectorsAlmostEqual(os.rampDemand,...
        min(l./scen.dt, min(rmax, self.u)));
    end
    
    
    function testProperMergingRules(self)
      os = self.states; scen = self.scen;
      
      for k = 1:scen.T
        for i = 1:scen.N+1
          if i == 1
            fout = 0;
            foff = 0;
            del = 0;
          else
            del = os.demand(k,i-1);
            fout = os.fluxOut(k,i-1);
            foff = os.fluxOffRamp(k,i-1);
          end
          if i == scen.N + 1
            fin = 0;
            fon = 0;
            beta = 1;
            p = 1;
            sig = inf;
            d = 0;
          else
            d = os.rampDemand(k,i);
            sig = os.supply(k,i);
            fon = os.fluxRamp(k,i);
            fin = os.fluxIn(k,i);
            beta = scen.BC.beta(k,i);
            p = scen.links(i).p;
          end
          
          if sig > del*(1 - beta) + d
            assertElementsAlmostEqual(fout, del);
            assertElementsAlmostEqual(fon,  d);
          else
            assertElementsAlmostEqual(fin, sig);
            if sig * p / (1 - beta) > del
              assertElementsAlmostEqual(fout, del);
              assertElementsAlmostEqual(fon, sig - del*(1 - beta));
            elseif sig * (1 - p) > d
              assertElementsAlmostEqual(fon, d);
              assertElementsAlmostEqual(fout, (sig - d)/(1 - beta));
            else
              assertElementsAlmostEqual(fout, p*sig / ( 1- beta));
              assertElementsAlmostEqual(fon, (1- p)*sig);
            end
          end
        end
      end
    end
    
    function tearDown(self)
    end
  end
    
    
end