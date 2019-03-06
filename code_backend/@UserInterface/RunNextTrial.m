function [trials, runningVals, quitKeyPressed] = RunNextTrial(obj, trials, settings, runningVals)
% RUNNEXTTRIAL - Run the next trial in the session, based on the current
% trial number (runningVals.currentTrial) and the data in the 'trials'
% struct array. Returns updated copies of 'trials' and 'runningVals', as 
% well as a boolean 'quitKeyPressed' indicating whether a quit key was
% pressed to end the experiment session. This function also takes care of 
% all timestamping and data logging within each trial.
%
% Usage: [trials, runningVals, quitKeyPressed] = RunNextTrial(trials, settings, runningVals);
% -------------------

% If the escape or q key is pressed, this will be set to true and passed as 
% such to the Main_SSRT script, which will then end the experiment session. 
quitKeyPressed = false; %#ok<NASGU>

% Display the bet cue
Screen('DrawTexture', obj.window, obj.choice, []);
obj.DrawPerformanceMetrics(settings, runningVals);
[~, BetCueOn, ~, ~, ~] = Screen('Flip',obj.window); % GetSecs called internally for timestamp
trials(runningVals.currentTrial).BetOnsetTimestamp = BetCueOn;

timedout = false;
while ~timedout
    
    % Check for responses while also getting a timestamp (1 = lower, 2 = higher)
    RestrictKeysForKbCheck([settings.RespondLowerKeyCodes, settings.RespondHigherKeyCodes]);
    [ keyIsDown, keyTime, keyCode ] = KbCheck(settings.RespondDeviceIndex); % keyTime is from an internal call to GetSecs
    RestrictKeysForKbCheck([]);
    
    if (keyIsDown)
        
        trials(runningVals.currentTrial).ResponseTimestamp = keyTime;
        trials(runningVals.currentTrial).BetRT = keyTime - BetCueOn;
        runningVals.LastGoRT = keyTime - BetCueOn; % For live performance metrics
        
        trials(runningVals.currentTrial).ResponseKeyName = KbName(keyCode);
        
        if ismember(find(keyCode), settings.RespondLowerKeyCodes)
            trials(runningVals.currentTrial).Answer = 1;
        elseif ismember(find(keyCode), settings.RespondHigherKeyCodes)
            trials(runningVals.currentTrial).Answer = 2;
        end
        
        break;
    end
    
    % Check for quit key press
    RestrictKeysForKbCheck(settings.QuitKeyCodes);
    [ keyIsDown, ~, keyCode ] = KbCheck(settings.ControlDeviceIndex); % keyTime is from an internal call to GetSecs
    RestrictKeysForKbCheck([]);
    
    if keyIsDown && ismember(find(keyCode), settings.QuitKeyCodes)
        quitKeyPressed = true;
        return;
    end
    
    % Time out after BetDur if no key is pressed
    if ((keyTime - BetCueOn) > settings.BetDur)
        trials(runningVals.currentTrial).Answer = 0;
        timedout = true;
    end
end

% Update the live performance metrics that are optionally displayed on
% the screen (see ExperimentSettings.m to disable/enable)
runningVals = obj.UpdateLivePerfMetrics(runningVals, trials);

% Display the choice cue
if trials(runningVals.currentTrial).Answer == 1
    Screen('DrawTexture', obj.window, obj.lower, []);
    obj.DrawPerformanceMetrics(settings, runningVals);
    [~, trials(runningVals.currentTrial).RespCueOn, ~, ~, ~] = Screen('Flip',obj.window);
elseif trials(runningVals.currentTrial).Answer == 2
    Screen('DrawTexture', obj.window, obj.higher, []);
    obj.DrawPerformanceMetrics(settings, runningVals);
    [~, trials(runningVals.currentTrial).RespCueOn, ~, ~, ~] = Screen('Flip',obj.window);
end

if ~timedout
    % Display choice until 3 seconds was up.
    quitKeyPressed = obj.WaitAndCheckQuit(settings.BetDur-((trials(runningVals.currentTrial).ResponseTimestamp-trials(runningVals.currentTrial).BetOnsetTimestamp)/1000), settings);
    if quitKeyPressed
        return;
    end
end

% First jittered fixation
trials(runningVals.currentTrial).Fix1Dur = random(truncate(makedist('Exponential',settings.sFixDurMean),settings.sFixDurMin,settings.sFixDurMax));
[trials(runningVals.currentTrial).Fix1OnsetTimestamp, ~] = obj.ShowFixation(trials(runningVals.currentTrial).Fix1Dur, settings, runningVals);

% Choose expectancy cue based on procedure name
switch trials(runningVals.currentTrial).Procedure
    case {'win', 'disp'}
        expCue = obj.ExpWin;
        trials(runningVals.currentTrial).ExpectancyStimulus = obj.exp_cue_names{1};
        
    case {'lose', 'relief'}
        expCue = obj.ExpLoss;
        trials(runningVals.currentTrial).ExpectancyStimulus = obj.exp_cue_names{2};
        
    case {'amb-win', 'amb-lose'}
        expCue = obj.ExpAmb;
        trials(runningVals.currentTrial).ExpectancyStimulus = obj.exp_cue_names{3};
        
    case {'neutral'}
        expCue = obj.ExpNeut;
        trials(runningVals.currentTrial).ExpectancyStimulus = obj.exp_cue_names{4};
        
    otherwise
        error('Invalid procedure name');
end

% Display expectancy cue, log onset time
Screen('DrawTexture', obj.window, expCue, []);
obj.DrawPerformanceMetrics(settings, runningVals);
[~, trials(runningVals.currentTrial).ExpOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window); % GetSecs called internally for timestamp

% Expectancy duration
quitKeyPressed = obj.WaitAndCheckQuit(settings.ExpDur, settings);
if quitKeyPressed
    return;
end

% Second jittered fixation
trials(runningVals.currentTrial).Fix2Dur = random(truncate(makedist('Exponential',settings.sFixDurMean),settings.sFixDurMin,settings.sFixDurMax));
[trials(runningVals.currentTrial).Fix2OnsetTimestamp, ~, quitKeyPressed] = obj.ShowFixation(trials(runningVals.currentTrial).Fix2Dur, settings, runningVals);
if quitKeyPressed
    return;
end

% Determine the outcome/"feed" cue to be used and log the feed cue name
switch trials(runningVals.currentTrial).Procedure
    case {'win', 'amb-win'}
        % Choose a "win" cue that's consistent with the participant's bet
        if trials(runningVals.currentTrial).Answer == 1
            cueNum = randsample(1:4,1);
        elseif trials(runningVals.currentTrial).Answer == 2
            cueNum = randsample(6:9,1);
        else
            % If the participant didn't make a bet, choose a random card
            cueNum = randsample([1:4 6:9],1);
        end
        feedCue = obj.win_cues{cueNum};
        trials(runningVals.currentTrial).FeedStimulus = obj.win_cue_names{cueNum};
        
    case {'lose', 'amb-lose'}
        % Choose a "lose" cue that's consistent with the participant's bet
        if trials(runningVals.currentTrial).Answer == 1
            cueNum = randsample(6:9,1);
        elseif trials(runningVals.currentTrial).Answer == 2
            cueNum = randsample(1:4,1);
        else
            % If the participant didn't make a bet, choose a random card
            cueNum = randsample([1:4 6:9],1);
        end
        feedCue = obj.loss_cues{cueNum};
        trials(runningVals.currentTrial).FeedStimulus = obj.loss_cue_names{cueNum};
        
    case {'disp', 'relief', 'neutral'}
        % Choose the neutral feed cue (participant's bet doesn't matter)
        feedCue = obj.Neut;
        trials(runningVals.currentTrial).FeedStimulus = obj.neut_cue_name;
        
    otherwise
        error('Invalid procedure name');
end

% Display the outcome/feed cue
Screen('DrawTexture', obj.window, feedCue, []);
obj.DrawPerformanceMetrics(settings, runningVals);
[~, trials(runningVals.currentTrial).FeedCueOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);
quitKeyPressed = obj.WaitAndCheckQuit(settings.FeedDur, settings);
if quitKeyPressed
    return;
end
    
% Inter-trial interval (ITI)
trials(runningVals.currentTrial).Fix3Dur = random(truncate(makedist('Exponential',settings.FixDurMean),settings.FixDurMin,settings.FixDurMax));
[trials(runningVals.currentTrial).Fix3OnsetTimestamp, ~, quitKeyPressed] = obj.ShowFixation(trials(runningVals.currentTrial).Fix3Dur, settings, runningVals);

% Re-enable all keys (restricted during trial)
RestrictKeysForKbCheck([]);

end