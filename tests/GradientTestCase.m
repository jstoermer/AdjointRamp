classdef GradientTestCase < TestCase
  
  properties
    scen;
    states;
    u;
    gradient;
    gradinfo;
    fn;
    dhdx;
  end

  methods
    
    function self = GradientTestCase(name)
      self = self@TestCase(name);
      self.fn = '../networks/samitha1onrampcomplex.json';
      disp('yeah???');
      self.whatever();
    end
    
    function whatever(self)
      loadParameters;
      self.scen = loadScenario(self.fn);
      [states, u] = forwardSimulation(self.scen);
      self.states = states;
      self.u = u;
      [grad, info] = gradientRampControl(self.scen, self.states, u);
      self.gradient = grad;
      self.gradinfo = info;
      self.dhdx = full(self.gradinfo.dhdx);
    end
    
    
    function setUp(self)
      return;
    end
    
    
    function testLowerTriangularDHDX(self)
      n = length(self.dhdx);
      for i = 1:n
        assertElementsAlmostEqual(self.dhdx(i,i), 1);
        assertElementsAlmostEqual(sum(abs(self.dhdx(i,i+1:end))), 0);
      end
    end
    
    function testTemporalDensityQueue(self)
      N = self.scen.N; T = self.scen.T;
      for k = 2:T
        for i = 1:N
          assertElementsAlmostEqual(self.dhdx(idx(N,k,'rho',i), idx(N,k-1,'rho',i)), -1);
          assertElementsAlmostEqual(self.dhdx(idx(N,k,'l',i), idx(N,k-1,'l',i)), -1);          
        end
      end
    end
    
    function testDJDX(self)
      djdx = full(self.gradinfo.djdx); N = self.scen.N; T = self.scen.T;
      for k = 1:T+1
        for i = 1:N
          xi = idx(N,k,'rho',i);
          assertElementsAlmostEqual(djdx(xi), self.scen.links(i).L);
          xi = idx(N,k,'l',i);
          assertElementsAlmostEqual(djdx(xi), 1);
        end
      end
      assertElementsAlmostEqual(sum(abs(djdx)),...
        sum([self.scen.links.L])*(T+1) + N*(T+1))
    end
    
    function testDHDU(self)
      
    end
    
    
    function tearDown(self)
    end
  end
    
    
end
