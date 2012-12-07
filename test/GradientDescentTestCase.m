classdef GradientDescentTestCase < TestCase
  %GRADIENTDESCENTTESTCASE Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
  end
  
  methods
    function self = GradientDescentTestCase(name)
      self = self@TestCase(name);
      setup;
    end
    
    function testXSquared(self)
      n = 1000;
      inits = randn(n,1);
      optimalU = 0;
      global parameters;
      parameters.alpha = 1;
      colls = descentCollection;
      descs = {colls.gdBasic, colls.gdBackTracking, colls.bfgs};
      for j = 1:length(descs)
        desc = descs{j};
        for i = 1:n
          u0 =inits(i);
          u = desc(u0, @cost, @grad);
          assertVectorsAlmostEqual(u, optimalU);
        end
      end
    end
  end
  
end

function out = cost(u)
out = u.^2;
end

function out = grad(u)
out = 2*u;
end