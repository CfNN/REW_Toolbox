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

% Show choice screen
if trials(runningVals.currentTrial).Answer == 1
    disp('One');
    Screen('DrawTexture', obj.window, obj.lower, []);
    [~, trials(runningVals.currentTrial).RespCueOn, ~, ~, ~] = Screen('Flip',obj.window);
elseif trials(runningVals.currentTrial).Answer == 2
    disp('Two');
    Screen('DrawTexture', obj.window, obj.higher, []);
    [~, trials(runningVals.currentTrial).RespCueOn, ~, ~, ~] = Screen('Flip',obj.window);
else    % Need to make sure kbcheck is empty prior to if clause or there will be errors
    disp(['Other: ' num2str(trials(runningVals.currentTrial).Answer)]);
end

% Display choice until 3 seconds was up.
WaitSecs(settings.BetDur-((trials(runningVals.currentTrial).ResponseTimestamp-trials(runningVals.currentTrial).BetOnsetTimestamp)/1000));

% First jittered fixation
Screen('DrawTexture', obj.window, obj.fixation, []);
[~, trials(runningVals.currentTrial).Fix1OnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);
trials(runningVals.currentTrial).Fix1Dur = random(truncate(makedist('Exponential',settings.sFixDurMean),settings.sFixDurMin,settings.sFixDurMax));
WaitSecs(trials(runningVals.currentTrial).Fix1Dur);

% Display expectancy cue (determined by the trial type) and log onset time.
if trials(runningVals.currentTrial).ProcedureNum < 3
    trials(runningVals.currentTrial).Stimulus = obj.exp_cues{1};
    Screen('DrawTexture', obj.window, obj.ExpWin, []);
    [~, trials(runningVals.currentTrial).ExpOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window); % GetSecs called internally for timestamp

elseif trials(runningVals.currentTrial).ProcedureNum > 2 && trials(runningVals.currentTrial).ProcedureNum < 5
    trials(runningVals.currentTrial).Stimulus = obj.exp_cues{2};
    Screen('DrawTexture', obj.window, obj.ExpLoss, []);
    [~, trials(runningVals.currentTrial).ExpOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

elseif trials(runningVals.currentTrial).ProcedureNum > 4 && trials(runningVals.currentTrial).ProcedureNum < 7
    trials(runningVals.currentTrial).Stimulus = obj.exp_cues{3};
    Screen('DrawTexture', obj.window, obj.ExpAmb, []);
    [~, trials(runningVals.currentTrial).ExpOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);

elseif trials(runningVals.currentTrial).ProcedureNum > 6
    trials(runningVals.currentTrial).Stimulus = obj.exp_cues{4};
    Screen('DrawTexture', obj.window, obj.ExpNeut, []);
    [~, trials(runningVals.currentTrial).ExpOnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);
end

% Expectancy duaration
trials(runningVals.currentTrial).ExpDur = 2;
WaitSecs(trials(runningVals.currentTrial).ExpDur);

% Second jittered fixation
Screen('DrawTexture', obj.window, obj.fixation, []);
[~, trials(runningVals.currentTrial).Fix2OnsetTimestamp, ~, ~, ~] = Screen('Flip',obj.window);
trials(runningVals.currentTrial).Fix2Dur = random(truncate(makedist('Exponential',settings.sFixDurMean),settings.sFixDurMin,settings.sFixDurMax));
WaitSecs(trials(runningVals.currentTrial).Fix2Dur);

% Display outcome (determined by cond + Answer) 
if (trials(runningVals.currentTrial).ProcedureNum == 1 || trials(runningVals.currentTrial).ProcedureNum == 5) && trials(runningVals.currentTrial).Answer == 1    %Expected win or amb win
    trials(runningVals.currentTrial).Feed = obj.win_cues{1,randsample(1:4,1)};
    Screen('DrawTexture', obj.window, trials(runningVals.currentTrial).Feed, []);
    [~, trials(runningVals.currentTrial).FeedCueOn, ~, ~, ~] = Screen('Flip',obj.window);

elseif (trials(runningVals.currentTrial).ProcedureNum == 1 || trials(runningVals.currentTrial).ProcedureNum == 5) && trials(runningVals.currentTrial).Answer == 2
    trials(runningVals.currentTrial).Feed = obj.win_cues{1,randsample(6:9,1)};
    Screen('DrawTexture', obj.window, trials(runningVals.currentTrial).Feed, []);
    [~, trials(runningVals.currentTrial).FeedCueOn, ~, ~, ~] = Screen('Flip',obj.window);

elseif (trials(runningVals.currentTrial).ProcedureNum == 3 || trials(runningVals.currentTrial).ProcedureNum == 6) && trials(runningVals.currentTrial).Answer == 1    %Expected loss or amb loss
    trials(runningVals.currentTrial).Feed = obj.loss_cues{1,randsample(1:4,1)};
    Screen('DrawTexture', obj.window, trials(runningVals.currentTrial).Feed, []);
    [~, trials(runningVals.currentTrial).FeedCueOn, ~, ~, ~] = Screen('Flip',obj.window);

elseif (trials(runningVals.currentTrial).ProcedureNum == 3 || trials(runningVals.currentTrial).ProcedureNum == 6) && trials(runningVals.currentTrial).Answer == 2
    trials(runningVals.currentTrial).Feed = obj.loss_cues{1,randsample(6:9,1)};
    Screen('DrawTexture', obj.window, trials(runningVals.currentTrial).Feed, []);
    [~, trials(runningVals.currentTrial).FeedCueOn, ~, ~, ~] = Screen('Flip',obj.window);

else
    trials(runningVals.currentTrial).Feed = obj.Neut;
    Screen('DrawTexture', obj.window, trials(runningVals.currentTrial).Feed, []);
    [~, trials(runningVals.currentTrial).FeedCueOn, ~, ~, ~] = Screen('Flip',obj.window);
end

WaitSecs(settings.FeedDur);
    
% ITI
trials(runningVals.currentTrial).Fix3OnsetTimestamp = GetSecs;
trials(runningVals.currentTrial).Fix3Dur = random(truncate(makedist('Exponential',settings.FixDurMean),settings.FixDurMin,settings.FixDurMax));
WaitSecs(trials(runningVals.currentTrial).Fix3Dur);


% Re-enable all keys (restricted during trial)
RestrictKeysForKbCheck([]);

end