function [  ] = fCopyFunction( funName )
% This copies necessary functions to the userpath in order to make them
% available throughout the calculations

% funName = 'myFunction.m'
% call in script simply by fCopyFunction('myFunction.m')

funName = [funName];
% derive userpath directory
path = userpath;
path = path(1:length(path));

% Set function name(s) to be copied 
% funName = 'ifNaN.m';

% copy
sourcePath = [pwd '\' num2str(funName)];
copyfile(sourcePath, path, 'f');

end

