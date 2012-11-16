classdef OptimalUTestCase < TestCase
  
  properties
    scen;
    statesI;
    statesF;
    uI;
    uF;
    fn;
  end

  methods
    
    function self = OptimalUTestCase(name)
      self = self@TestCase(name);
      self.fn = '../networks/samitha1onramp.json';
    end
    
    
    function setUp(self)
      loadParameters;
      self.scen = loadScenario(self.fn);
      [states, u] = forwardSimulation(self.scen);
      self.uI = u;
      self.statesI = states;
      
      self.uF = optimalU(scen, u);
      self.statesF = forwardSimulation(scen, self.uF);
      
    end
    
    function tearDown(self)
    end
  end
    
    
end
