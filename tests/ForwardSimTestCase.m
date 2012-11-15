classdef ForwardSimTestCase < TestCase
  
  properties
    scen;
    states;
    u;
  end

  methods
    
    function self = ForwardSimTestCase(name)
      self = self@TestCase(name);
    end
    
    
    function setUp(self)
      self.scen = loadScenario('../networks/samitha1onramp.json');
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
      
      nextCars = rho(2:end, :).*repmat(L, scen.T, 1); 
      prevCars = rho(1:end-1, :).*repmat(L, scen.T, 1); 
      carsIn = os.fluxIn .* scen.dt;
      carsOut = os.fluxOut .* scen.dt;
      
      assertVectorsAlmostEqual(nextCars, prevCars + carsIn - carsOut);
    end
    
    
    function tearDown(self)
    end
  end
    
    
end