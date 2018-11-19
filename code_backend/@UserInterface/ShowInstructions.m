function ShowInstructions(obj)
% SHOWINSTRUCTIONS - Show a series of introductory/instruction screens
%   Usage: ShowInstructions();
% See also SHOWREADYTIMER
% -------------------

% User can proceed by hitting any key. 
% Change to (eg.) activeKeys = [KbName('space'), KbName('return')] to only 
% respond to the space or enter keys. 
activeKeys = [];
RestrictKeysForKbCheck(activeKeys);

instructions = [ % Use \n to start a new line. Just one \n doesn't give enough space - best to use two or three
    'Now we''re ready to start the card game!\n\n\n',...
    'Cards in the deck are numbered 1 to 9...\n\n\n',...
    'When you see the ? cue, guess whether the next card is over or under a 5.\n\n',...
    'Press the LEFT key with your index finger to guess LOWER than 5.\n\n',...
    'Press the RIGHT key with your middle finger to guess HIGHER than 5.\n\n\n',...
    'Make your guess as FAST as you can.\n\n\n',...
    'The next cue will tell you to expect a win, loss, or no change in $.\n\n\n',...
    'Finally, we''ll show you the outcome of your bet!\n\n\n',...
    'Please tell the Experimenter when you are ready to start.'
    ];

Screen('TextSize', obj.window, 80);
Screen('TextFont', obj.window, 'Courier New');
Screen('TextSTyle', obj.window, 1); % 1 makes it bold;

DrawFormattedText(obj.window, 'Card Guessing Game', 'center', 'center', obj.c_yellow);

Screen('Flip', obj.window); % Flip to the screen
KbStrokeWait; % Wait for key press

Screen('TextSize', obj.window, 24);
Screen('TextSTyle', obj.window, 0);

DrawFormattedText(obj.window, instructions, 'center', 'center', obj.c_yellow);

Screen('Flip', obj.window); % Flip to the screen
KbStrokeWait; % Wait for key press

end
