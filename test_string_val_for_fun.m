%% test string validation for function
p = inputParser;
argName = 'monkey';
monkeys = { 'toejam','earl' };
% validationFcn = @(x) any(validatestring(x,monkeys));
validationFcn = @(x) any(strcmp(x,monkeys));
addRequired(p,argName,validationFcn);

parse(p,'toejam')


p = inputParser;
argName = 'monkey';
monkeys = [ "toejam","earl" ];
validationFcn = @(x) validateStringParameter(x,monkeys,mfilename,argName);
addRequired(p,argName,validationFcn);

function validateStringParameter(varargin)
    validatestring(varargin{:});
end

@(inVal)any(strcmp(inVal,possVal)) 