classdef SimpleFSTestCase < ForwardSimTestCase
  
  methods
    function self = SimpleFSTestCase(name)
      self = self@ForwardSimTestCase(name);
      self.fn = '../networks/simple.json';
    end
  end
end
