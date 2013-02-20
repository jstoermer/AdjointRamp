  function out = morphU(fn, scen, upos)
    % take a function which requires unstacked u, and return a function
    % which takes stacked u, and feeds the unstacked version to the guy
    % underneath
    function varargout = helper(varargin)
      varargin{upos} = unstack(varargin{upos},scen);
      if strcmp(func2str(fn), 'dh_dx')
          [out2, out3] = fn(varargin{:});
          varargout{1} = out2;
          varargout{2} = out3;
      else
          out2 = fn(varargin{:});
          varargout{1} = out2;
      end % if
    end
  out = @helper;
  end