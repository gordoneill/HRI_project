function operation()
global qhome;
%% Init Game
globals;
[myo, leap, actin, unity] = initExternalDevices();

tool       = 'brain';%selectTool();
robai      = robot(actin, unity);
action     = 'rest';
lastAction = 'rest';
trainObj   = train('C:\GitHub\MiniVIE\gordon_test.trainingData');
robai.goHome(qhome);
pause(2);
grabTool(tool, t, robai);

while ~strcmp(action, 'release')
    %% Collect Data
    myoData  = collectMyoData(myo, trainObj);
    leapData = collectLeapData(leap);

    %% Determine Action
    action = determineAction(trainObj, leapData, myoData);
    
    if ~strcmp(action, 'rest') && strcmp(action, lastAction) % need action twice to enact
        [traj, timesteps]  = determineTraj(action, tool);

        % Move Robot
        if ~isempty(traj)
            disp('Moving');
            robai.move(traj, timesteps); 
            action = 'rest';
        end
    else
        pause(0.1);        
    end
    lastAction = action;
end

robai.goHome(qhome);
cleanup;
