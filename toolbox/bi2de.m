function d = bi2de(b, varargin)
%BI2DE Convert binary vectors to decimal numbers.
%   D = BI2DE(B) converts a binary vector B to a decimal value D. When B is
%   a matrix, the conversion is performed row-wise and the output D is a
%   column vector of decimal values. The default orientation of the binary
%   input is Right-MSB; the first element in B represents the least
%   significant bit.
%
%   In addition to the input matrix, two optional parameters can be given:
%
%   D = BI2DE(...,P) converts a base P vector to a decimal value.
%
%   D = BI2DE(...,MSBFLAG) uses MSBFLAG to determine the input orientation.
%   MSBFLAG has two possible values, 'right-msb' and 'left-msb'.  Giving a
%   'right-msb' MSBFLAG does not change the function's default behavior.
%   Giving a 'left-msb' MSBFLAG flips the input orientation such that the
%   MSB is on the left.
%
%   Examples:
%       B = [0 0 1 1; 1 0 1 0];
%       T = [0 1 1; 2 1 0];
%
%       D = bi2de(B)     
%       E = bi2de(B,'left-msb')     
%       F = bi2de(T,3)
%
%   See also DE2BI.

%   Copyright 1996-2018 The MathWorks, Inc.

  %%% Input validation:
  if nargin<1 || nargin>3
    error(message('comm:bi2de:IncorrectNumInputs'));
  end
  [b_double, inType, p, msbFlag] = validateInputs(b, varargin{:});
  
  d = comm.internal.utilities.bi2de(b_double, p, msbFlag, inType);

end

function [b, inType, p, msbFlag] = validateInputs(b, varargin)

  %%% 1st argument validation:
  validateattributes(b, {'logical', 'numeric'}, {'nonempty', 'real', ...
    'integer', 'nonnegative' }, '', 'binary vector b', 1);
  
  inType = class(b);
  b = double(b);  % All internal processing is done in double representation

  %%% Secondary input arguments:
  p = 2; % default base
  msbFlag = 'right-msb'; %default MSB orientation

  for i=1:length(varargin)

    thisArg = varargin{i};
    %%% Base argument (p):
    
    if isnumeric(thisArg)

      validateattributes(thisArg, {'numeric'}, {'nonempty', 'scalar', ...
                    'real', 'integer', 'finite', '>', 1}, '', 'base p', 1+i);
      
      p	= thisArg; % Set up the base to convert from.

    %%% Flag argument 'left-msb' / 'right-msb':
    elseif comm.internal.utilities.isCharOrStringScalar(thisArg)

      if ~any(strcmp(thisArg, {'left-msb', 'right-msb'}))
        error(message('comm:bi2de:InvalidMSBFlag'));
      end
      
      msbFlag = thisArg;

    else
      error(message('comm:bi2de:InvalidInputArg'));
    end
  end

  if max(max(b(:))) > (p-1)
    error(message('comm:bi2de:InvalidInputElement'));
  end
end
