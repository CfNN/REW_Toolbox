classdef UserInterface < handle
    % USERINTERFACE - Wrapper class that contains PsychToolbox functions. Main
    % script 'Main_SSRT.m' works primarily by using functions in this class.
    
    properties (GetAccess=private)
        
        % Screen properties
        window;
        windowRect;
        screenXpixels;
        screenYpixels;
        xCenter;
        yCenter;
        
        % Images
        choice;
        higher;
        lower;
        fixation;
        ExpWin;
        ExpLoss;
        ExpAmb;
        ExpNeut;
        Loss1;
        Loss2;
        Loss3;
        Loss4;
        Loss6;
        Loss7;
        Loss8;
        Loss9;
        Neut;
        Win1;
        Win2;
        Win3;
        Win4;
        Win6;
        Win7;
        Win8;
        Win9;
        
        % Figure reference lists
        exp_cue_names;
        win_cues;
        win_cue_names;
        loss_cues;
        loss_cue_names;
        neut_cue_name;
    end
        
    properties % public access
        
    end
    
    properties(Constant)
        %---COLOR DEFINITIONS---%
        c_black = [0 0 0]; % formerly BlackIndex(screenNumber);
        c_white = [1 1 1]; % formerly WhiteIndex(screenNumber);
        c_yellow = [1 1 0];
    end
    
    methods
        function obj = UserInterface(settings)  %#ok<INUSD>
            
            % Seed random number generator
            rng('shuffle');
            
            % Call some default settings for setting up Psychtoolbox
            PsychDefaultSetup(2);
            
            % Skip screen synchronization checks. There can be < 3ms timing
            % errors on some operating systems (Linux has best timing)
            Screen('Preference', 'SkipSyncTests', 1);
            
            %---KEYBOARD SETUP---%
            
            % Needed for the experiment to run on different operating systems with
            % different key code systems
            KbName('UnifyKeyNames');
            
            % Enable all keyboard keys for key presses
            RestrictKeysForKbCheck([]);
            
            
            %---SCREEN SETUP---%
            
            % Skip sync checks if running on Windows or Mac. Running on Windows 
            % or Mac (as opposed to Linux) may cause stimulus timing errors 
            % of up to a few milliseconds.
            if contains(upper(computer), 'MAC') || contains(upper(computer), 'WIN')
                Screen('Preference', 'SkipSyncTests', 1);
            end
            
            % Get the screen numbers
            screens = Screen('Screens');
            
            % Select the external screen if it is present, else revert to the native
            % screen
            screenNumber = max(screens);
            
            % Open an on screen window and color it grey
            [obj.window, obj.windowRect] = PsychImaging('OpenWindow', screenNumber, obj.c_black);
            
            % Set the blend function for the screen (anti-aliasing)
            Screen('BlendFunction', obj.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
            
            % Get the size of the on screen window in pixels
            % For help see: Screen WindowSize?
            [obj.screenXpixels, obj.screenYpixels] = Screen('WindowSize', obj.window);
            %             obj.screenXpixels = obj.windowRect(1,3);
            %             obj.screenYpixels = obj.windowRect(1,4);
            % Get the centre coordinate of the window in pixels
            % For help see: help RectCenter
            [obj.xCenter, obj.yCenter] = RectCenter(obj.windowRect);
            
            %---IMAGE SETUP---%
            choiceFig = imread('images/choice.jpg');
            higherFig = imread('images/higher.jpg');
            lowerFig = imread('images/lower.jpg');
            fixFig = imread('images/fixation.jpg');
            ExpWinFig = imread('images/ExpWin.jpg');
            ExpLossFig = imread('images/ExpLoss.jpg');
            ExpAmbFig = imread('images/ExpAmb.jpg');
            ExpNeutFig = imread('images/ExpNeut.jpg');
            Loss1Fig = imread('images/Loss1.jpg');
            Loss2Fig = imread('images/Loss2.jpg');
            Loss3Fig = imread('images/Loss3.jpg');
            Loss4Fig = imread('images/Loss4.jpg');
            Loss6Fig = imread('images/Loss6.jpg');
            Loss7Fig = imread('images/Loss7.jpg');
            Loss8Fig = imread('images/Loss8.jpg');
            Loss9Fig = imread('images/Loss9.jpg');
            NeutFig = imread('images/Neut.jpg');
            Win1Fig = imread('images/Win1.jpg');
            Win2Fig = imread('images/Win2.jpg');
            Win3Fig = imread('images/Win3.jpg');
            Win4Fig = imread('images/Win4.jpg');
            Win6Fig = imread('images/Win6.jpg');
            Win7Fig = imread('images/Win7.jpg');
            Win8Fig = imread('images/Win8.jpg');
            Win9Fig = imread('images/Win9.jpg');
            
            obj.choice = Screen('MakeTexture', obj.window, choiceFig);
            obj.higher = Screen('MakeTexture', obj.window, higherFig);
            obj.lower = Screen('MakeTexture', obj.window, lowerFig);
            obj.fixation = Screen('MakeTexture', obj.window, fixFig);
            obj.ExpWin = Screen('MakeTexture', obj.window, ExpWinFig);
            obj.ExpLoss = Screen('MakeTexture', obj.window, ExpLossFig);
            obj.ExpAmb = Screen('MakeTexture', obj.window, ExpAmbFig);
            obj.ExpNeut = Screen('MakeTexture', obj.window, ExpNeutFig);
            obj.Loss1 = Screen('MakeTexture', obj.window, Loss1Fig);
            obj.Loss2 = Screen('MakeTexture', obj.window, Loss2Fig);
            obj.Loss3 = Screen('MakeTexture', obj.window, Loss3Fig);
            obj.Loss4 = Screen('MakeTexture', obj.window, Loss4Fig);
            obj.Loss6 = Screen('MakeTexture', obj.window, Loss6Fig);
            obj.Loss7 = Screen('MakeTexture', obj.window, Loss7Fig);
            obj.Loss8 = Screen('MakeTexture', obj.window, Loss8Fig);
            obj.Loss9 = Screen('MakeTexture', obj.window, Loss9Fig);
            obj.Neut = Screen('MakeTexture', obj.window, NeutFig);
            obj.Win1 = Screen('MakeTexture', obj.window, Win1Fig);
            obj.Win2 = Screen('MakeTexture', obj.window, Win2Fig);
            obj.Win3 = Screen('MakeTexture', obj.window, Win3Fig);
            obj.Win4 = Screen('MakeTexture', obj.window, Win4Fig);
            obj.Win6 = Screen('MakeTexture', obj.window, Win6Fig);
            obj.Win7 = Screen('MakeTexture', obj.window, Win7Fig);
            obj.Win8 = Screen('MakeTexture', obj.window, Win8Fig);
            obj.Win9 = Screen('MakeTexture', obj.window, Win9Fig);
            
            obj.exp_cue_names = {'ExpWin.jpg','ExpLoss.jpg','ExpAmb.jpg','ExpNeut.jpg'};
            obj.win_cues = {obj.Win1,obj.Win2,obj.Win3,obj.Win4, NaN, obj.Win6,obj.Win7,obj.Win8,obj.Win9};
            obj.win_cue_names = {'Win1.jpg', 'Win2.jpg', 'Win3.jpg', 'Win4.jpg', NaN, 'Win6.jpg', 'Win7.jpg', 'Win8.jpg', 'Win9.jpg'};
            obj.loss_cues = {obj.Loss1,obj.Loss2,obj.Loss3,obj.Loss4, NaN, obj.Loss6,obj.Loss7,obj.Loss8,obj.Loss9};
            obj.loss_cue_names = {'Loss1.jpg', 'Loss2.jpg', 'Loss3.jpg', 'Loss4.jpg', NaN, 'Loss6.jpg', 'Loss7.jpg', 'Loss8.jpg', 'Loss9.jpg'};
            obj.neut_cue_name = 'Neut.jpg';
        end
        
        quitKeyPressed = ShowInstructions(obj, settings);
        
        [triggerTimestamp, sessionStartDateTime, quitKeyPressed] = ShowReadyTrigger(obj, settings);
        
        [onsetTimestamp, offsetTimestamp, quitKeyPressed] = ShowFixation(obj, duration, settings, runningVals);
        
        [trials, runningVals, quitKeyPressed] = RunNextTrial(obj, trials, settings, runningVals);
        
        quitKeyPressed = WaitAndCheckQuit(obj, duration, settings);
        
    end
    
    methods (Access = private)
        runningVals = UpdateLivePerfMetrics(obj, runningVals, trials);
        DrawPerformanceMetrics(obj, settings, runningVals);
    end
end