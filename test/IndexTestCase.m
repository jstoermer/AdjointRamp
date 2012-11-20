classdef IndexTestCase < TestCase
  properties
    N
  end
  methods
    function self = IndexTestCase(name)
      self = self@TestCase(name);
      self.N = 30;
    end
    
    function testUIDX(self)
      assertEqual(uidx(self.N, 1, 1), 1);
      assertEqual(uidx(self.N, 1, 7), 7);
      assertEqual(uidx(self.N, 2, 1), self.N + 1);
    end
    
    function testIDX(self)
      assertEqual(idx(self.N, 1, 1, 1), 1);
      assertEqual(idx(self.N, 1, 2, 1), self.N + 1);
      assertEqual(idx(self.N, 1, 1, 2), 2);
      assertEqual(idx(self.N, 3, 1, 1), 2*(self.N*8) + 1);
      assertEqual(idx(self.N, 2, 2, 1), self.N*8 + self.N + 1);
      assertEqual(idx(self.N, 2, 2, 2), self.N*8 + self.N + 2);
    end
    
    
    
  end
end
