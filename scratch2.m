function scratch2()
% This will be renamed to Main_REW when ready for testing
% To run an experiment session, enter "Main_SSRT" into the MATLAB console, 
% or press the "Run" betton in the menu above under the "EDITOR" tab. 

% Clear the workspace and the screen, close all plot windows
close all;
clear;
sca;

% Set user-defined variables to configure experiment. creates a workspace
% struct variable called 'settings'. Settings variables should NEVER change
% during the experiment session. 
ExperimentSettings;

% Set up running values that change during the experiment session (live 
% performance metrics, two changing stop-signal delays associated with the 
% two staircases) 
InitRunningVals;   

% Timestamps for beginning of experiment
sessionStartDateTime = datevec(now);
runningVals.GetSecsStart = GetSecs;

% Use dialog boxes to get subject number, session number, etc. from the experimenter
[subjectNumber, sessionNumber, subjectHandedness, runningVals, cancelled] = GetSessionConfig(settings, runningVals);
if (cancelled)
    disp('Session cancelled by experimenter');
    return; % Stops this script from running to end the experiment session
end
clear cancelled;

% Initialize the user interface (ui) and PsychToolbox
ui = UserInterface(settings);

% Use the ui to show experiment instructions
ui.ShowInstructions();

% Use the ui to show the "ready" screen with a timer, and wait for the MRI
% trigger (or a key press, depending on what is specified in
% ExperimentSettings.m)
triggerTimestamp = ui.ShowReadyTrigger();

% Use the ui to show a fixation cross for the specified amount of time in
% seconds
ui.ShowFixation(0.5, runningVals);

% Condition and stim names (these could be put in a sub function???)
cond_names = {'win','disp','lose','relief','amb-win','amb-lose','neutral'};
exp_cues = {'ExpWin.jpg','ExpLoss.jpg','ExpAmb.jpg','ExpNeut.jpg'};
win_cues = [obj.Win1,obj.Win2,obj.Win3,obj.Win4,obj.Win6,obj.Win7,obj.Win8,obj.Win9];
loss_cues = [obj.Loss1,obj.Loss2,obj.Loss3,obj.Loss4,obj.Loss6,obj.Loss7,obj.Loss8,obj.Loss9];

% After trigger wait for x seconds
trigger = GetSecs
tic
WaitSecs(6)

% This section calls RunNextTrial...

    [trials, runningVals] = RunNextTrial(obj, trials, settings, runningVals)
    
   
    
    
    
    
   
   
    
    
    
    
    
WaitSecs(6)
toc   
    
studytime = GetSecs-trigger

% This is just junk code for pulling out timing info. Will be handled in a seperate function later...
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




