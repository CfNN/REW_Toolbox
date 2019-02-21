% CLEANUP from ExperimentSettings.m (removing redundant and confusing 
% settings variables, setting up additional variables)

settings.QuitKeyCodes = zeros(1, numel(settings.QuitKeyNames));
for n = 1:numel(settings.QuitKeyNames)
    settings.QuitKeyCodes(n) = KbName(settings.QuitKeyNames{n});
end