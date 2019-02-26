% To run an experiment session, enter "Main_REW" into the MATLAB console, 
% or press the "Run" betton in the menu above under the "EDITOR" tab. 

% Giant try-catch block enables PsychToolbox to exit gracefully in the
% event of an error (rather than freezing and possibly requiring reboot)
try
    % Clear the workspace and the screen, close all plot windows
    close all;
    clear;
    sca;

    % Shuffle random number generator (necessary to avoid getting the same
    % "random" numbers each time
    rng('shuffle');

    % Set the current MATLAB folder to the folder where this script is stored
    disp('Setting the current MATLAB folder to the location of this script');
    cd(fileparts(which(mfilename)));

    % Make sure the code files in /code_backend and other directories are accessible to MATLAB
    disp('Adding code directories to MATLAB search path');
    addpath('./code_backend/'); 

    try
        % Contains the pre-generated "trials" struct array
        load('CURRENTTRIALS.mat', 'trials');
    catch
        error('CURRENTTRIALS.mat not found. Generate a trial sequence by running GenRandomTrials.m. Type ''help GenRandomTrials'' in the MATLAB console for information on how to use this function.');
    end

    % Set user-defined variables to configure experiment. creates a workspace
    % struct variable called 'settings'. Settings variables should NEVER change
    % during the experiment session. 
    ExperimentSettings;

    % Set up running 2values that change during the experiment session (e.g. 
    % live performance metrics)
    InitRunningVals;   

    % Use dialog boxes to get subject number, session number, etc. from the experimenter
    [subjectNumber, sessionNumber, subjectHandedness, cancelled] = GetSessionConfig(settings);
    if (cancelled)
        disp('Session cancelled by experimenter');
        return; % Stops this script from running. Do not use quit() here because PsychToolbox is not yet started
    end
    clear cancelled;

    % Initialize the user interface (ui) and PsychToolbox
    ui = UserInterface(settings);

    % This must be called after the UI starts, since it uses PsychToolbox functions
    ExperimentSettingsCleanup;

    % Use the ui to show experiment instructions
    quitKeyPressed = ui.ShowInstructions(settings);
    if quitKeyPressed
        cleanup();
        return  % Stops this script from running to end experiment session
    end

    % Use the ui to show the "ready" screen with a timer, and wait for the MRI
    % trigger (or a key press, depending on what is specified in
    % ExperimentSettings.m)
    % IMPORTANT: sessionStartDateTime is not exactly the same as
    % triggerTimestamp, there is be a (tiny) time difference between when
    % the two are recorded! For this reason, always use triggerTimestamp for 
    % important calculations if possible. 
    [triggerTimestamp, sessionStartDateTime, quitKeyPressed] = ui.ShowReadyTrigger(settings);
    if quitKeyPressed
        cleanup();
        return  % Stops this script from running to end experiment session
    end

    % Use the ui to show a fixation cross for the specified amount of time in seconds
    [sessionStartFixationOnsetTimestamp, sessionStartFixationOffsetTimestamp, quitKeyPressed] = ui.ShowFixation(settings.SessionStartFixationDur, settings, runningVals);
    if quitKeyPressed
        cleanup();
        return  % Stops this script from running to end experiment session
    end

    % Loop through the trials structure (note - runningVals.currentTrial keeps
    % track of which trial you are on)
    while (runningVals.currentTrial <= length(trials))

        [trials, runningVals, quitKeyPressed] = ui.RunNextTrial(trials, settings, runningVals);
        if quitKeyPressed
            cleanup();
            return  % Stops this script from running to end experiment session
        end

        % Autosave data in case the experiment is interrupted partway through
        save(['subj' num2str(subjectNumber) '_sess' num2str(sessionNumber) '_' settings.ExperimentName '_AUTOSAVE.mat'], 'trials', 'settings', 'subjectNumber', 'sessionNumber', 'subjectHandedness', 'triggerTimestamp', 'sessionStartDateTime', 'sessionStartFixationOnsetTimestamp', 'sessionStartFixationOffsetTimestamp');

        % Advance iterator to next trial
        runningVals.currentTrial = runningVals.currentTrial + 1;

    end  

    [sessionEndFixationOnsetTimestamp, sessionEndFixationOffsetTimestamp, quitKeyPressed] = ui.ShowFixation(settings.SessionEndFixationDur, settings, runningVals);
    if quitKeyPressed
        cleanup();
        return  % Stops this script from running to end experiment session
    end

    % Save the data to a .mat, delete autosaved version
    save(['subj' num2str(subjectNumber) '_sess' num2str(sessionNumber) '_' settings.ExperimentName '.mat'], 'trials', 'settings', 'subjectNumber', 'sessionNumber', 'subjectHandedness', 'triggerTimestamp', 'sessionStartDateTime', 'sessionStartFixationOnsetTimestamp', 'sessionStartFixationOffsetTimestamp', 'sessionEndFixationOnsetTimestamp', 'sessionEndFixationOffsetTimestamp');
    delete(['subj' num2str(subjectNumber) '_sess' num2str(sessionNumber) '_' settings.ExperimentName '_AUTOSAVE.mat']);

    cleanup();
    
catch e
    cleanup();
    rethrow(e);
end

function cleanup()
    % Clear the screen and unneeded variables.
    sca;
    clear ui filename;
end