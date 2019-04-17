function operation()

%% Init Game
globals;
[myo, leap, actin, unity] = initExternalDevices();

tool       = selectTool();
robai      = robot(actin, unity);
action     = 'rest';
lastAction = 'rest';
trainObj   = train(uigetfile('*.trainingData', 'Select Training Data'));
robai.goHome();

while ~strcmp(action, 'release')
    %% Collect Data
    myoData  = collectMyoData(myo, trainObj);
    leapData = collectLeapData(leap);

    %% Determine Action
    action = determineAction(trainObj, leapData, myoData);
    
    if ~strcmp(action, 'rest') && strcmp(action, lastAction) % need action twice to enact
        traj = determineTraj(action, tool);

        %% Move Robot
        robai.move(traj);
    end
    
    lastAction = action;
end

robai.goHome();
cleanup;
