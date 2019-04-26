function operation()
global qhome;
%% Init Game
globals;
[myo, leap, actin, unity] = initExternalDevices();

%tool       = selectTool();
robai      = robot(actin, unity);
action     = 'rest';
lastAction = 'rest';
% trainObj   = train('C:\GitHub\MiniVIE\gordon_finalProj.trainingData');
robai.goHome(qhome);

while ~strcmp(action, 'release')
    %% Collect Data
%     myoData  = collectMyoData(myo, trainObj);
%     leapData = collectLeapData(leap);

    %% Determine Action
%     action = determineAction(trainObj, leapData, myoData);

    action = 'rest';
    tool = 'wrench';
    
    if ~strcmp(action, 'rest') && strcmp(action, lastAction) % need action twice to enact
        [traj, timesteps]  = determineTraj(action, tool);

        % Move Robot
        if ~isempty(traj)
            robai.move(traj, timesteps);  
        end
    else
        pause(0.1);        
    end
    lastAction = action;
end

% robai.goHome(qhome);
cleanup;
