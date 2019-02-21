% CLEANUP from ExperimentSettings.m (removing redundant and confusing 
% settings variables, setting up additional variables)

settings.QuitKeyCodes = zeros(1, numel(settings.QuitKeyNames));
for n = 1:numel(settings.QuitKeyNames)
    settings.QuitKeyCodes(n) = KbName(settings.QuitKeyNames{n});
end

settings.RespondLowerKeyCodes = zeros(1, numel(settings.RespondLowerKeyNames));
for n = 1:numel(settings.RespondLowerKeyNames)
    settings.RespondLowerKeyCodes(n) = KbName(settings.RespondLowerKeyNames{n});
end

settings.RespondHigherKeyCodes = zeros(1, numel(settings.RespondHigherKeyNames));
for n = 1:numel(settings.RespondHigherKeyNames)
    settings.RespondHigherKeyCodes(n) = KbName(settings.RespondHigherKeyNames{n});
end