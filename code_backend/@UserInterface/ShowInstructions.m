function quitKeyPressed = ShowInstructions(obj, settings)
% SHOWINSTRUCTIONS - Show a series of introductory/instruction screens
%   Usage: ShowInstructions();
% See also SHOWREADYTRIGGER
% -------------------

% Default value, will be set to true if the quit key is pressed
quitKeyPressed = false;

% Experimenter can proceed by hitting any key. 
% Change to (eg.) activeKeys = [KbName('space'), KbName('return') settings.QuitKeyCodes] 
% to only respond to the space or enter keys. You must include the
% QuitKeyCodes if you want to be able to quit from this screen.
activeKeys = [];
RestrictKeysForKbCheck(activeKeys);

instructions = [ % Use \n to start a new line. Just one \n doesn't give enough space - best to use two or three
    
    'When you see the "?", guess the value of the next card.\n\n\n',...
    'Use your INDEX finger and the "1" key to guess LOWER than 5.\n\n',...
    'Use your MIDDLE finger and the "2" key to guess HIGHER than 5.\n\n\n',...
    'Next, you''l see the likely outcome of your guess.\n\n\n',...
    'Finally, you''ll see how much you won or lost!'
    ];

Screen('TextSize', obj.window, 80);
Screen('TextFont', obj.window, 'Courier New');
Screen('TextSTyle', obj.window, 1); % 1 makes it bold;

DrawFormattedText(obj.window, 'Card Guessing Game', 'center', 'center', obj.c_white);

Screen('Flip', obj.window); % Flip to the screen

[~, keyCode, ~] = KbStrokeWait(settings.ControlDeviceIndex); % Wait for key press

% quit if quit key was pressed
if ismember(find(keyCode), settings.QuitKeyCodes)
    quitKeyPressed = true;
    return;
end

Screen('TextSize', obj.window, 40);
Screen('TextSTyle', obj.window, 0);

DrawFormattedText(obj.window, instructions, 'center', 'center', obj.c_white);

Screen('Flip', obj.window); % Flip to the screen

[~, keyCode, ~] = KbStrokeWait(settings.ControlDeviceIndex); % Wait for key press

% quit if quit key was pressed
if ismember(find(keyCode), settings.QuitKeyCodes)
        quitKeyPressed = true;
        return;
end

end
