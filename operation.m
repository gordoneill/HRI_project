function operation()
global qhome;
global curPose;
%% Init Game
globals;
[myo, leap, actin, unity] = initExternalDevices();

tool       = selectTool();
robai      = robot(actin, unity);
action     = 'rest';
lastAction = 'rest';
trainObj   = train('C:\GitHub\MiniVIE\gordon_finalProj.trainingData');
curJoints = robaiBot.ikine(curPose);
robai.goHome(convertRobotAnglestoJointAngles(curJoints), qhome);
curPose = homePose;

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

curJoints = robaiBot.ikine(curPose);
robai.goHome(convertRobotAnglestoJointAngles(curJoints), qhome);
curPose = homePose;
cleanup;
