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
      dhdu = full(self.gradinfo.dhdu); N = self.scen.N; T = self.scen.T;
      counter = 0;
      % test for active constraints
      for k = 1:T
        for i = 1:N
          hi = idx(N,k,'d',i);
          xi = uidx(N,k,i);
          dhduval = dhdu(hi,xi);
          uval = self.u(k,i);
          rval = self.scen.links(i).rmax;
          lval = self.states.queue(k,i);
          if uval < rval && uval < lval / self.scen.dt
            assertElementsAlmostEqual(dhduval, -1); % active u constraint
            counter = counter + 1; % number of active elements
          else
            assertElementsAlmostEqual(dhduval, 0); % not active
          end
        end
      end
      
      % test for all other values = 0
      assertEqual(length(find(dhdu)), counter);
    end
    
    function testDJDU(self)
      global parameters
      djdu = full(self.gradinfo.djdu); N = self.scen.N; T = self.scen.T;
      % test for active violations
      for k = 1:T
        for i = 1:N
          xi = uidx(N,k,i);
          djduval = djdu(xi);
          uval = self.u(k,i);
          rval = self.scen.links(i).rmax;
          lval = self.states.queue(k,i);
          assertElementsAlmostEqual(djduval, parameters.R*(max(uval - min(lval / self.scen.dt, rval), 0)^2));
        end
      end
    end
    
    
    function tearDown(self)
    end
  end
    
    
end
