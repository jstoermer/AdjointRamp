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
      setup;
    end
    
    function testHighLevel(self)
      %TESTHIGHLEVEL Testing the big units
      %   Detailed explanation goes here
      
      
      for i = 1:length(self.fns)
        fn  = self.fns{i};
        fprintf(['\n\n======Running ' fn '======\n\n']);
        disp('load scenario');
        tic
        scen = io.loadScenario([self.dir fn]);
        toc
        
        structures = rampAdjointStructures(scen);
        structure = structures.structure;
        u = chooseInitialU(scen, .5);
        
        disp('forward sim');
        tic
        states = structure.updateStates(u);
        toc
        
        self.gradient(scen, structure, u);
      end
    end
    
    function gradient(self, scen, str, u)
      
      
      states = str.getStates();
      fprintf('\n');
      disp('dhdx');
      tic
      dhdx = str.partials.dhdx(scen, states, u);
      toc
      
      fprintf('\n');
      disp('dhdu');
      tic
      dhdu = str.partials.dhdu(scen, states, u);
      toc
      
      fprintf('\n');
      disp('djdx');
      tic
      djdx = str.partials.djdx(scen, states, u);
      toc
      
      fprintf('\n');
      disp('djdu');
      tic
      djdu = str.partials.djdu(scen, states, u);
      toc
      
      fprintf('\n');
      disp('system solution');
      tic
      str.solveSystem(dhdx, djdx, djdu, dhdu);
      toc
      
    end
    
    
    function tearDown(self)
    end
  end
  
  
end



