function operation()

%% Init Game
[myo, leap, actin, unity] = initExternalDevices();
Tools
tool = selectTool();
robai = robot(actin, unity);
%robai.goHome();
action = 'rest';
trainObj = train(uigetfile('*.trainingData', 'Select Training Data'));

while ~strcmp(action, 'release')
    %% Collect Data
    myoData  = collectMyoData(myo, trainObj);
    leapData = collectLeapData(leap);

    %% Determine Action
    action = determineAction(trainObj, leapData, myoData);
    [traj, duration] = determineTraj(action, tool);
    
    %% Move Robot
    robai.move(traj, duration);
end

%robai.goHome();
cleanup;
