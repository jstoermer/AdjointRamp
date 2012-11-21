classdef OptimalUTestCase < TestCase
  
  properties
  end

  methods
    
    function self = OptimalUTestCase(name)
      self = self@TestCase(name);
      self.fn = '../networks/samitha1onramp.json';
    end
    
    
    function setUp(self)
      loadParameters;      
    end
    
    function tearDown(self)
    end
  end
    
    
end
