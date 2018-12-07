function runningVals = UpdateLivePerfMetrics(~, runningVals, trials)
% UPDATELIVEPERFMETRICS - Updates variables needed to display live 
% performance metrics. 
%
% Usage: runningVals = UpdateLivePerfMetrics(runningVals, trials)
% -------------

runningVals.ResponseRate = nnz(rmmissing([trials.Answer])) / numel(rmmissing([trials.Answer]));
runningVals.ResponseRate = round( 100 * runningVals.ResponseRate);

runningVals.PreviousAnswer = trials(runningVals.currentTrial).Answer;

end