function DrawWinnings(obj, runningVals)
% Draws winnings counter at the bottom of the the screen, without 
% flipping the screen yet (flipping must be done AFTER calling this 
% function). 
% 
% Usage: DrawWinnings(runningVals);

moneyStr = ['$' num2str(abs(runningVals.winnings), '%.2f')];

if runningVals.winnings < 0
    moneyStr = ['-' moneyStr];
end

Screen('TextSize', obj.window, 40);
Screen('TextFont', obj.window, 'Courier New');
Screen('TextSTyle', obj.window, 0); % 0 is regular (not bold, italicized, etc)
% Change the value in "obj.screenYpixels - 20" to modify the vertical
% position of the winnings counter. 
DrawFormattedText(obj.window, ['Total winnings: ' moneyStr], 'center', obj.screenYpixels - 200, obj.c_white);

end