classdef PerformanceTest < TestCase
  
  properties
    dir
    fns
    dfuns
  end
  
  methods
    
    function self = PerformanceTest(name)
      self = self@TestCase(name);
      self.dir = '../networks/';
      self.fns = {'simple.json', 'samitha1onramp.json','2on2off.json'};
      % self.fns = {'2on2off.json'};
      % self.fns = {'simple.json', 'samitha1onramp.json'};
      self.dfuns = rampPartialFunctions;
    end
    
    
    function setUp(self)
      loadParameters;
    end
    
    function testHighLevel(self)
      %TESTHIGHLEVEL Testing the big units
      %   Detailed explanation goes here
      
      
      for i = 1:length(self.fns)
        fn  = self.fns{i};
        fprintf(['\n\n======Running ' fn '======\n\n']);
        disp('load scenario');
        tic
        scen = loadScenario([self.dir fn]);
        toc
        disp('forward sim');
        tic
        [states, u] = forwardSimulation(scen);
        toc
        self.gradient(scen, states, u);
      end
    end
    
    function gradient(self, scen, states, u)
      fns = self.dfuns;
      
      fprintf('\n');
      disp('dhdx');
      tic
      dhdx = fns.dhdx(scen,states, u);
      toc
      
      fprintf('\n');
      disp('dhdu');
      tic
      dhdu = fns.dhdu(scen,states, u);
      toc
      
      fprintf('\n');
      disp('djdx');
      tic
      djdx = fns.djdx(scen,states, u);
      toc
      
      fprintf('\n');
      disp('djdu');
      tic
      djdu = fns.djdu(scen,states, u);
      toc
      
      fprintf('\n');
      disp('system solution');
      tic
      adjointGradient(dhdx, djdx, djdu, dhdu);
      toc
      
    end
      
    
    function tearDown(self)
    end
  end
  
  
end



