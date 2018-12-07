try
    disp(['Psychtoolbox install directory: ' PsychtoolboxRoot]);
catch
    warning('Psychtoolbox not installed. Install it using instructions on this page: http://psychtoolbox.org/download');
end

% Make sure the code files in /code_backend and other directories are accessible to MATLAB
disp('Adding code directories to MATLAB search path...');
addpath('./code_backend/');
disp('Finished adding code directories to MATLAB search path');
