function operation()

%% Init Game
[myo, leap, actin, unity] = initExternalDevices();
tool = selectTool();
robai = construct(actin, unity);
robai.goHome();
action = 'rest';

while ~strcmp(action, 'release')
    %% Collect Data
    myoData  = collectMyoData(myo);
    leapData = collectLeapData(leap);

    %% Determine Action
    action = determineAction(myoData, leapData);
    [traj, duration] = determineTraj(action);
    
    %% Move Robot
    if strcmp(action,'grip')
        robai.grip(tool);
    else
        robai.move(traj, duration);
    end
end

cleanup;
