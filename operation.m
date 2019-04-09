function operation()

%% Init Game
[myo, leap, actin, unity] = initExternalDevices();
tool = selectTool();
robai = robot(actin, unity);
%robai.goHome();
action = 'rest';
trainObj = train('C:\GitHub\MiniVIE\gordon_finalProj.trainingData');

while ~strcmp(action, 'release')
    %% Collect Data
    myoData  = collectMyoData(myo, trainObj);
    leapData = collectLeapData(leap);

    %% Determine Action
    action = determineAction(trainObj, leapData, myoData);
    [traj, duration] = determineTraj(action);
    
    %% Move Robot
    if strcmp(action,'grip')
        robai.grip(tool);
    else
        robai.move(traj, duration);
    end
end

cleanup;
