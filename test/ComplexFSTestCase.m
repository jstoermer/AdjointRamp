classdef ComplexFSTestCase < ForwardSimTestCase
  
  methods
    function self = ComplexFSTestCase(name)
      self = self@ForwardSimTestCase(name);
      self.fn = '../networks/samitha1onramp.json';
    end
  end
end

