function order = GenRandomTrials(n, n_block)
% GENRANDOMTRIALS - Generates a pseudo-random trial sequence. 
% n: # conditions. 
%
% n_block: Number of blocks of trials.
%
% ----------------

n = n + 1;  %Adjusted to account for overrepresentation of 'neutral'

% Set up the counterbalance
b1 = counterbalance(n);
b2 = fliplr(b1);
b = vertcat(b2,b1);
y = randsample(1:size(b,1),n_block);
order = b(y,:);
order(order==n)=(n-1);
order = reshape(order',[1,numel(order)])';

