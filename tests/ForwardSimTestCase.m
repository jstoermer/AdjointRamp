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
    
    function tearDown(self)
    end
  end
    
    
end