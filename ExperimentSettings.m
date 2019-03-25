% INVESTIGATOR: Edit this file to customize the parameters of your SSRT
% experiment. Note that these values should not change during the entire
% experiment session (the running ssd values are stored in runningVals). 

% Set the name of the experiment, which will be added to the name of saved
% data files:
settings.ExperimentName = 'REW';

% Set whether an MRI trigger will be used to start the experiment
% (otherwise a key press will be used)
settings.UseMRITrigger = false;
settings.MRITriggerManufacturer = 'Current Designs, Inc.';
settings.MRITriggerUsageName = 'Keyboard';

% Index of the keyboard/other device that the participant will use to make
% their responses. To see keyboard device indices, type GetKeyboardIndices()
% into the MATLAB command window and use the resulting value. For other
% device indices, type devices = PsychHID('devices'), and examine the
% "index" field in the "devices" struct that is created. To enable any
% device/keyboard to make a response, leave the field equal to []. 
settings.RespondDeviceIndex = [];

% Index of the keyboard/other device used to control the flow of the
% experiment (e.g. pressing "continue" on instructions screens, pressing
% the quit key to end the session early). Set by the same procedure as
% settings.RespondDeviceIndex above.
settings.ControlDeviceIndex = [];

% Enter the keys that can be used to indicate "lower" and "higher" responses.
settings.RespondLowerKeyNames = {'1', '1!', 'LeftArrow'};
settings.RespondHigherKeyNames = {'2', '2@', 'RightArrow'};

% Enter the names of the key(s) that you want to designate as "quit keys":
% When you press one of these, the session will immediately end (with data
% autosaved).
settings.QuitKeyNames = {'q', 'escape'};

% Set to "true" to display live performance metrics at the bottom of the 
% screen during the experiment. To hide the metrics, set to "false"
settings.DisplayPerfMetrics = true;

% Set to "true" to use a variable fixation cross duration, chosen for each
% trial from a truncated exponential distribution. Set to "false" to use a
% constant fixation duration, specified below as settings.FixationDur
settings.VariableFixationDur = true;

% Parameters for fixation duration distribution (truncated exponential):
% NOT APPLICABLE if settings.VariableFixationDur is set to false
% Short fixation lengths
settings.sFixDurMean = 1.25;
settings.sFixDurMin = 1.75;
settings.sFixDurMax = 2.5;

% ITI fixation length
settings.FixDurMean = 1;
settings.FixDurMin = 0.75;
settings.FixDurMax = 2.5;

% Constant duration of fixation before each trial
% NOT APPLICABLE if settings.VariableFixationDur is set to true
settings.FixDur = 0.5; % seconds

% Duration to display fixation cross before and after running the trials
% (e.g. to collect 'resting' data and avoid truncating HRF in MRI studies)
settings.SessionStartFixationDur = 6; % seconds
settings.SessionEndFixationDur = 10; % seconds

%Set variables called by counterbalance
settings.nconds = 7;
settings.nblocks = 6;

% Total bet duration.
settings.BetDur = 1.5;

% Total RE duration.
settings.ExpDur = 1.25;

% Outcome screen duration
settings.FeedDur = 1.25;