function [trials, runningVals, quitKeyPressed] = RunNextTrial(obj, trials, settings, runningVals)
% RUNNEXTTRIAL - Run the next trial in the session, based on the current
% trial number (runningVals.currentTrial) and the data in the 'trials'
% struct array. Returns updated copies of 'trials' and 'runningVals'. This
% function also takes care of all timestamping and data logging within each
% trial.
%
% Usage: [trials, runningVals] = RunNextTrial(trials, runningVals);
% -------------------

% If the escape or q key is pressed, this will be set to true and passed as 
% such to the Main_SSRT script, which will then end the experiment session. 
quitKeyPressed = false;

% Call keyboard or buttonbox code
% Specify allowable key names, restrict input to these
activeKeys = [KbName('1') KbName('2') KbName('1!') KbName('2@') KbName('Escape') KbName('q')];
RestrictKeysForKbCheck(activeKeys);

keyMap = containers.Map;
keyMap('1') = 1;
keyMap('2') = 2;
keyMap('1!') = 1;
keyMap('2@') = 2;

% Display the bet cue
Screen('DrawTexture', obj.window, obj.choice, []);
obj.DrawPerformanceMetrics(runningVals);
[~, BetCueOn, ~, ~, ~] = Screen('Flip',obj.window); % GetSecs called internally for timestamp
trials(runningVals.currentTrial).BetOnsetTimestamp = BetCueOn;

timedout = false;
while ~timedout
    
    % Check for keyboard presses while also getting a timestamp (1=lower, 2=higher)
    [ keyIsDown, keyTime, keyCode ] = KbCheck; % keyTime is from an internal call to GetSecs
    if (keyIsDown)
        
        % Quit if quit key pressed
        if strcmpi(KbName(keyCode), 'q') || strcmpi(KbName(keyCode), 'escape')
                quitKeyPressed = true;
                return;
        end
        
        trials(runningVals.currentTrial).ResponseTimestamp = keyTime;
        trials(runningVals.currentTrial).BetRT = keyTime - BetCueOn;
        runningVals.LastGoRT = keyTime - BetCueOn; % For live performance metrics
        trials(runningVals.currentTrial).Answer = keyMap(KbName(keyCode));
        break;
    end 
    
    % Time out after BetDur if no key is pressed
    if ((keyTime - BetCueOn) > obj.settings.BetDur)
        trials(runningVals.currentTrial).Answer = 0;
        timedout = true;
    end
end

% Update the live performance metrics that are optionally displayed on
% the screen (see ExperimentSettings.m to disable/enable)
runningVals = obj.UpdateLivePerfMetrics(runningVals, trials);

% Show choice screen
if trials(runningVals.currentTrial).Answer == 1
    Screen('DrawTexture', obj.window, obj.lower, []);
    obj.DrawPerformanceMetrics(runningVals);
    [~, trials(runningVals.currentTrial).RespCueOn, ~, ~, ~] = Screen('Flip',obj.window);
elseif trials(runningVals.currentTrial).Answer == 2
    Screen('DrawTexture', obj.window, obj.higher, []);
    obj.DrawPerformanceMetrics(runningVals);
    [~, trials(runningVals.currentTrial).RespCueOn, ~, ~, ~] = Screen('Flip',obj.window);
else    % Need to make sure kbcheck is empty prior to if clause or there will be errors
end

% Display choice until 3 seconds was up.
WaitSecs(settings.BetDur-((trials(runningVals.currentTrial).ResponseTimestamp-trials(runningVals.currentTrial).BetOnsetTimestamp)/1000));

% First jittered fixation
trials(runningVals.currentTrial).Fix1Dur = random(truncate(makedist('Exponential',settings.sFixDurMean),settings.sFixDurMin,settings.sFixDurMax));
[trials(runningVals.currentTrial).Fix1OnsetTimestamp, ~] = obj.ShowFixation(trials(runningVals.currentTrial).Fix1Dur, runningVals);

% Display expectancy cue (determined by the trial type) and log onset time.
if trials(runningVals.currentTrial).ProcedureNum < 3
    trials(runningVals.currentTrial).ExpectancyStimulus = obj.exp_cue_names{1};
    Screen('DrawTexture', obj.window, obj.ExpWin, []);
    obj.DrawPerformanceMetrics(runningVals);
    [~, trials(runningVals.currentTrial).ExpOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window); % GetSecs called internally for timestamp

elseif trials(runningVals.currentTrial).ProcedureNum > 2 && trials(runningVals.currentTrial).ProcedureNum < 5
    trials(runningVals.currentTrial).ExpectancyStimulus = obj.exp_cue_names{2};
    Screen('DrawTexture', obj.window, obj.ExpLoss, []);
    obj.DrawPerformanceMetrics(runningVals);
    [~, trials(runningVals.currentTrial).ExpOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

elseif trials(runningVals.currentTrial).ProcedureNum > 4 && trials(runningVals.currentTrial).ProcedureNum < 7
    trials(runningVals.currentTrial).ExpectancyStimulus = obj.exp_cue_names{3};
    Screen('DrawTexture', obj.window, obj.ExpAmb, []);
    obj.DrawPerformanceMetrics(runningVals);
    [~, trials(runningVals.currentTrial).ExpOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

elseif trials(runningVals.currentTrial).ProcedureNum > 6
    trials(runningVals.currentTrial).ExpectancyStimulus = obj.exp_cue_names{4};
    Screen('DrawTexture', obj.window, obj.ExpNeut, []);
    obj.DrawPerformanceMetrics(runningVals);
    [~, trials(runningVals.currentTrial).ExpOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);
end

% Expectancy duaration
WaitSecs(settings.ExpDur);

% Second jittered fixation
trials(runningVals.currentTrial).Fix2Dur = random(truncate(makedist('Exponential',settings.sFixDurMean),settings.sFixDurMin,settings.sFixDurMax));
[trials(runningVals.currentTrial).Fix2OnsetTimestamp, ~] = obj.ShowFixation(trials(runningVals.currentTrial).Fix2Dur, runningVals);

% Determine the outcome/"feed" cue to be used and log the cue name
if (trials(runningVals.currentTrial).ProcedureNum == 1 || trials(runningVals.currentTrial).ProcedureNum == 5) && trials(runningVals.currentTrial).Answer == 1    %Expected win or amb win
    cueNum = randsample(1:4,1);
    feedCue = obj.win_cues{cueNum};
    trials(runningVals.currentTrial).FeedStimulus = obj.win_cue_names{cueNum};

elseif (trials(runningVals.currentTrial).ProcedureNum == 1 || trials(runningVals.currentTrial).ProcedureNum == 5) && trials(runningVals.currentTrial).Answer == 2
    cueNum = randsample(6:9,1);
    feedCue = obj.win_cues{cueNum};
    trials(runningVals.currentTrial).FeedStimulus = obj.win_cue_names{cueNum};

elseif (trials(runningVals.currentTrial).ProcedureNum == 3 || trials(runningVals.currentTrial).ProcedureNum == 6) && trials(runningVals.currentTrial).Answer == 1    %Expected loss or amb loss
    cueNum = randsample(1:4,1);
    feedCue = obj.loss_cues{cueNum};
    trials(runningVals.currentTrial).FeedStimulus = obj.loss_cue_names{cueNum};

elseif (trials(runningVals.currentTrial).ProcedureNum == 3 || trials(runningVals.currentTrial).ProcedureNum == 6) && trials(runningVals.currentTrial).Answer == 2
    cueNum = randsample(6:9,1);
    feedCue = obj.loss_cues{cueNum};
    trials(runningVals.currentTrial).FeedStimulus = obj.loss_cue_names{cueNum};

else
    feedCue = obj.Neut;
    trials(runningVals.currentTrial).FeedStimulus = 'Neut.jpg';
end

% Display the outcome/feed cue
Screen('DrawTexture', obj.window, feedCue, []);
obj.DrawPerformanceMetrics(runningVals);
[~, trials(runningVals.currentTrial).FeedCueOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);
WaitSecs(settings.FeedDur);
    
% Inter-trial interval (ITI)
trials(runningVals.currentTrial).Fix3Dur = random(truncate(makedist('Exponential',settings.FixDurMean),settings.FixDurMin,settings.FixDurMax));
[trials(runningVals.currentTrial).Fix3OnsetTimestamp, ~] = obj.ShowFixation(trials(runningVals.currentTrial).Fix3Dur, runningVals);

% Re-enable all keys (restricted during trial)
RestrictKeysForKbCheck([]);

end