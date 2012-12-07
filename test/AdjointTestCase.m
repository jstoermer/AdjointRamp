classdef AdjointTestCase < TestCase
  %GRADIENTDESCENTTESTCASE Summary of this class goes here
  %   Detailed explanation goes here
  
  properties
  end
  
  methods
    function self = AdjointTestCase(name)
      self = self@TestCase(name);
      clc;
      setup;
    end
    
    function testXSquared(self)
      global parameters;
      colls = descentCollection;
      descs = {colls.gdBackTracking, colls.bfgs};
      for i = 1:length(descs)
        descent = descs{i};
        state = @(data, u) (3 - 2*u) / 3;
        cost = @(data, x, u) x^2 + u^2;
        dhdx = @(data, x, u) 3;
        djdx = @(data, x, u) 2 * x;
        dhdu = @(data, x, u) 2;
        djdu = @(data, x, u) 2 * u;
        data = [];
        nus = 10;
        us = 10.*randn(nus,1);
        ustar = 6 / 13;
        xstar = 9/13;
        for i = 1:nus
          u0 = us(i);
          u = adjointOptimization(data, u0, state, cost, dhdx, djdx, dhdu, djdu, descent);
          x = state(data, u);
          assertVectorsAlmostEqual(u, ustar);
          assertVectorsAlmostEqual(x, xstar);
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