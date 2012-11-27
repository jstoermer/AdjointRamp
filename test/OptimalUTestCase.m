classdef OptimalUTestCase < TestCase
  
  properties
    fns
    directory
  end

  methods
    
    function self = OptimalUTestCase(name)
      self = self@TestCase(name);
      self.fns = {'samitha1onramp.json' ,'2on2off.json'};
      self.directory = '../networks/';
    end
    
    function testImprovement(self)
      for i = 1:length(self.fns)
        fn = self.fns{i};
        [scen, u] = io.loadScenario([self.directory fn]);
        self.assertUOptimalBetter(scen, u);
      end
    end
    
    function assertUOptimalBetter(self, scen, u)
      assertTrue(totalTravelTime(scen, u) > totalTravelTime(scen, rampOptimalU(scen, u)));
    end
    
    
    function setUp(self)
      setup;      
    end
    
    function tearDown(self)
    end
  end
    
    
end
