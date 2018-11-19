function scratch2()

% Condition and stim names
cond_names = {'win','disp','lose','relief','amb-win','amb-lose','neutral'};
exp_cues = {'ExpWin.jpg','ExpLoss.jpg','ExpAmb.jpg','ExpNeut.jpg'};
win_cues = [obj.Win1,obj.Win2,obj.Win3,obj.Win4,obj.Win6,obj.Win7,obj.Win8,obj.Win9];
loss_cues = [obj.Loss1,obj.Loss2,obj.Loss3,obj.Loss4,obj.Loss6,obj.Loss7,obj.Loss8,obj.Loss9];



trigger = GetSecs
tic
WaitSecs(6)

% This section calls RunNextTrial...

    [trials, runningVals] = RunNextTrial(obj, trials, settings, runningVals)
    
   
    
    
    
    
   
   
    
    
    
    
    
WaitSecs(6)
toc   
    
studytime = GetSecs-trigger

% trials1=trials;
% for i = 1:(n*n_block)
%     trials1(runningVals.currentTrial).BetOnsetTimestamp=trials1(runningVals.currentTrial).BetOnsetTimestamp-trigger;
%     trials1(runningVals.currentTrial).Fix1OnsetTimestamp=trials1(runningVals.currentTrial).Fix1OnsetTimestamp-trigger;
%     trials1(runningVals.currentTrial).ExpOnsetTimestamp=trials1(runningVals.currentTrial).ExpOnsetTimestamp-trigger;
%     trials1(runningVals.currentTrial).Fix2OnsetTimestamp=trials1(runningVals.currentTrial).Fix2OnsetTimestamp-trigger;
%     trials1(runningVals.currentTrial).NumOnsetTimestamp=trials1(runningVals.currentTrial).NumOnsetTimestamp-trigger;
%     trials1(runningVals.currentTrial).FeedOnsetTimestamp=trials1(runningVals.currentTrial).FeedOnsetTimestamp-trigger;
%     trials1(runningVals.currentTrial).Fix3OnsetTimestamp=trials1(runningVals.currentTrial).Fix3OnsetTimestamp-trigger;
% end

% conds=[trials1(:).cond];
% dlmwrite('win.txt',[trials1(find(conds==1)).ExpOnsetTimestamp]');
% dlmwrite('disp.txt',[trials1(find(conds==2)).ExpOnsetTimestamp]');
% dlmwrite('lose.txt',[trials1(find(conds==3)).ExpOnsetTimestamp]');
% dlmwrite('relief.txt',[trials1(find(conds==4)).ExpOnsetTimestamp]');
% dlmwrite('ambwin.txt',[trials1(find(conds==5)).ExpOnsetTimestamp]');
% dlmwrite('amblose.txt',[trials1(find(conds==6)).ExpOnsetTimestamp]');
% dlmwrite('neutral.txt',[trials1(find(conds==7)).ExpOnsetTimestamp]');
% 
% dlmwrite('winF.txt',[trials1(find(conds==1)).FeedOnsetTimestamp]');
% dlmwrite('dispF.txt',[trials1(find(conds==2)).FeedOnsetTimestamp]');
% dlmwrite('loseF.txt',[trials1(find(conds==3)).FeedOnsetTimestamp]');
% dlmwrite('reliefF.txt',[trials1(find(conds==4)).FeedOnsetTimestamp]');
% dlmwrite('ambwinF.txt',[trials1(find(conds==5)).FeedOnsetTimestamp]');
% dlmwrite('ambloseF.txt',[trials1(find(conds==6)).FeedOnsetTimestamp]');
% dlmwrite('neutralF.txt',[trials1(find(conds==7)).FeedOnsetTimestamp]');


    
    % To be set during/after the trial - initially set to NaN (not a number)
    trials(runningVals.currentTrial).Answer = NaN;     % Lower=1, higher=2
    trials(runningVals.currentTrial).Correct = false; %Boolean indicating whether Answer matches CorrectAnswer
    trials(runningVals.currentTrial).GoRT = NaN;
    trials(runningVals.currentTrial).SSD_intended = NaN;
    trials(runningVals.currentTrial).SSD_actual = NaN;
    % Timestamps
    trials(runningVals.currentTrial).GoSignalOnsetTimestamp = NaN;
    trials(runningVals.currentTrial).GoSignalOffsetTimestamp = NaN;
    trials(runningVals.currentTrial).StopSignalOnsetTimestamp = NaN;
    trials(runningVals.currentTrial).StopSignalOffsetTimestamp = NaN;
    trials(runningVals.currentTrial).ResponseTimestamp = NaN;
    
    trials(runningVals.currentTrial).FixationOffsetTimestamp = NaN;
    trials(runningVals.currentTrial).BlankOnsetTimestamp = NaN;
    trials(runningVals.currentTrial).BlankOffsetTimestamp = NaN;
end

possibleStopTrialPos = n_enforcedInitialGoTrials+1:n_trials;
stopTrialInds = randsample(possibleStopTrialPos, n_stopTrials);

% Boolean vector to keep track of which trials are stop trials
stop_trial = false(n_trials, 1);
stop_trial(stopTrialInds) = true;

% Assume that there might initially be too many consecutive stop trials 
% somewhere in the array
tooManyConsecutiveStopTrials = true; 

while(tooManyConsecutiveStopTrials)
    tooManyConsecutiveStopTrials = false;
    
    nConsecStop = 0;
    for i = 1:n_trials
        if stop_trial(runningVals.currentTrial)
            nConsecStop = nConsecStop + 1;
            if nConsecStop > n_maxConsecStopTrials
                tooManyConsecutiveStopTrials = true;
                stop_trial(runningVals.currentTrial) = false;
                % Choose a random go trial, after the enforced period of 
                % initial go trials, to change to a stop trial
                newStopTrialLoc = randsample(find(not(stop_trial(n_enforcedInitialGoTrials+1:end) )), 1) + n_enforcedInitialGoTrials;
                stop_trial(newStopTrialLoc) = true;
            end
        else
            nConsecStop = 0;
        end

    end
end

% Set a random half of the stop trials to staircase 1, the other half will
% be staircase 2
staircase1 = false(size(stop_trial));
staircase1(randsample(find(stop_trial), n_stopTrials/2)) = true;

for i = 1:n_trials
    if stop_trial(runningVals.currentTrial)
        if staircase1(runningVals.currentTrial)
            trials(runningVals.currentTrial).Procedure = 'StITrial';
        else
            trials(runningVals.currentTrial).Procedure = 'StITrial2';
        end
        trials(runningVals.currentTrial).CorrectAnswer = 0;
    end
end

assignin('base', 'trials', trials);
save('CURRENTTRIALS.mat', 'trials');
disp('Random ''trials'' struct saved as CURRENTTRIALS.mat');

