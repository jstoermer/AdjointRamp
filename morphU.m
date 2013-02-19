  function out = morphU(fn, scen, upos)
    % take a function which requires unstacked u, and return a function
    % which takes stacked u, and feeds the unstacked version to the guy
    % underneath
    function out2 = helper(varargin)
      varargin{upos} = unstack(varargin{upos},scen);
      out2 = fn(varargin{:});
    end
  out = @helper;
  end