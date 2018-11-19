classdef UserInterface < handle
    % USERINTERFACE - Wrapper class that contains PsychToolbox functions. Main
    % script 'Main_SSRT.m' works primarily by using functions in this class.
    
    properties (GetAccess=private)
        % Settings (initialized once by main script, never change during
        % experiment)
        settings;
        
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
        
    end
    
    properties(Constant)
        %---COLOR DEFINITIONS---%
        c_black = [0 0 0]; % formerly BlackIndex(screenNumber);
        c_white = [1 1 1]; % formerly WhiteIndex(screenNumber);
        c_yellow = [1 1 0];
    end
    
    methods
        function obj = UserInterface(settings_init)
            
            obj.settings = settings_init;
            
            % Call some default settings for setting up Psychtoolbox
            PsychDefaultSetup(2);
            
            
            %---KEYBOARD SETUP---%
            
            % Needed for the experiment to run on different operating systems with
            % different key code systems
            KbName('UnifyKeyNames');
            
            % Enable all keyboard keys for key presses
            RestrictKeysForKbCheck([]);
            
            
            %---SCREEN SETUP---%
            
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
            choiceFig = double(imread('pics/choice.jpg'));
            higherFig = double(imread('pics/higher.jpg'));
            lowerFig = double(imread('pics/lower.jpg'));
            fixFig = double(imread('pics/fixation.jpg'));
            ExpWinFig = double(imread('pics/ExpWin.jpg'));
            ExpLossFig = double(imread('pics/ExpLoss.jpg'));
            ExpAmbFig = double(imread('pics/ExpAmb.jpg'));
            ExpNeutFig = double(imread('pics/ExpNeut.jpg'));
            Loss1Fig = double(imread('pics/Loss1.jpg'));
            Loss2Fig = double(imread('pics/Loss2.jpg'));
            Loss3Fig = double(imread('pics/Loss3.jpg'));
            Loss4Fig = double(imread('pics/Loss4.jpg'));
            Loss6Fig = double(imread('pics/Loss6.jpg'));
            Loss7Fig = double(imread('pics/Loss7.jpg'));
            Loss8Fig = double(imread('pics/Loss8.jpg'));
            Loss9Fig = double(imread('pics/Loss9.jpg'));
            NeutFig = double(imread('pics/Neut.jpg'));
            Win1Fig = double(imread('pics/Win1.jpg'));
            Win2Fig = double(imread('pics/Win2.jpg'));
            Win3Fig = double(imread('pics/Win3.jpg'));
            Win4Fig = double(imread('pics/Win4.jpg'));
            Win6Fig = double(imread('pics/Win6.jpg'));
            Win7Fig = double(imread('pics/Win7.jpg'));
            Win8Fig = double(imread('pics/Win8.jpg'));
            Win9Fig = double(imread('pics/Win9.jpg'));
            
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
            
        end
        
        
        
        ShowInstructions(obj);
        
        TriggerTimestamp = ShowReadyTrigger(obj);
        
        trials = ShowFixation(obj, duration, runningVals, trials);
        
        trials = ShowBlank(obj, duration, runningVals, trials);
        
        [trials, runningVals] = RunNextTrial(obj, trials, settings, runningVals);
        
    end
    
    methods (Access = private)
        DrawPerformanceMetrics(obj, runningVals);
    end
end