function GenRandomTrials(n_conditions, n_block)
% GENRANDOMTRIALS - Generates a pseudo-random trial sequence. 
% n_conditions: Number of conditions. 
%
% n_block: Number of blocks of trials.


% Seed random number generator. Otherwise, the exact same 'random' sequence 
% of numbers will be generated each time after opening MATLAB.
rng('shuffle');

n_conditions = n_conditions + 1;  % Adjusted to account for overrepresentation of 'neutral'

% Set up the counterbalance
addpath('./code_backend/'); % add counterbalance function to MATLAB path
b1 = counterbalance(n_conditions);
b2 = fliplr(b1);
b = vertcat(b2,b1);
y = randsample(1:size(b,1),n_block);
order = b(y,:);
order(order==n_conditions)=(n_conditions-1);
order = num2cell(reshape(order',[1,numel(order)])');

trials(numel(order)) = struct();

[trials.ProcedureNum] = order{:};

cond_names = {'win','disp','lose','relief','amb-win','amb-lose','neutral'};
sequence = cond_names([trials.ProcedureNum]);
[trials.Procedure] = sequence{:};

% Set up fields for data logging, set to default values for all trials 
% (typically NaN or 'Not a Number')
trials = setdefault(trials, 'BetOnsetTimestamp', NaN);
trials = setdefault(trials, 'ResponseTimestamp', NaN);
trials = setdefault(trials, 'BetRT', NaN);
trials = setdefault(trials, 'Answer', NaN);
trials = setdefault(trials, 'RespCueOn', NaN);
trials = setdefault(trials, 'Fix1OnsetTimestamp', NaN);
trials = setdefault(trials, 'Fix2Dur', NaN);
trials = setdefault(trials, 'ExpOnsetTimestamp', NaN);
trials = setdefault(trials, 'Fix2OnsetTimestamp', NaN);
trials = setdefault(trials, 'Fix2Dur', NaN);
trials = setdefault(trials, 'Feed', NaN);
trials = setdefault(trials, 'FeedCueOnsetTimestamp', NaN);
trials = setdefault(trials, 'Fix3OnsetTimestamp', NaN);
trials = setdefault(trials, 'Fix3Dur', NaN);

assignin('base', 'trials', trials);
save('CURRENTTRIALS.mat', 'trials');
disp('Random ''trials'' struct saved as CURRENTTRIALS.mat');

end

function structarray = setdefault(structarray, fieldname, value)
% SETDEFAULT - sets a field of all elements of a struct array to the same
% default value
    temp_cell = repmat({value}, numel(structarray), 1);
    [structarray.(fieldname)] = temp_cell{:};
end
