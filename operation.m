function operation()
global robai;

%% Init Game
[myo, leap, actin, unity] = initExternalDevices();
globals;
%tool = selectTool();
tool = 'wrench';
robai = robot(actin, unity);
%robai.goHome();
action = 'rest';
%trainObj = train(uigetfile('*.trainingData', 'Select Training Data'));

while ~strcmp(action, 'release')
    %% Collect Data
    myoData  = collectMyoData(myo, trainObj);
    leapData = collectLeapData(leap);

    %% Determine Action
    action = determineAction(trainObj, leapData, myoData);
    traj = determineTraj('up', tool);
    
    %% Move Robot
    robai.move(traj);
end

%robai.goHome();
cleanup;
