function operation()
global qhome;
global curJoints;
global curPose;
%% Init Game
globals;
[myo, leap, actin, unity] = initExternalDevices();
robai       = robot(actin, unity);
organsMoved = containers.Map(organs,{0, 0, 0});
trainObj    = train('gordon.trainingData');

while (~organsMoved(organs(1)) || ~organsMoved(organs(2)) || ~organsMoved(organs(3)))
    organ = 'heart'; %selectOrgan();
    while organsMoved(organ)
        disp('Please select unmoved organ');
        organ = selectOrgan();
    end

    lastAction = 'rest';
    curJoints = robai.goHome(qhome);
    curPose = homePose;
    pause(1)
    grabOrgan(organ, t, robai);
    
    while ~organsMoved(organ)
        %% Collect Data
%         myoData  = collectMyoData(myo, trainObj);
%         leapData = collectLeapData(leap);

        %% Determine Action
%         action = determineAction(trainObj, leapData, myoData);
        action = input('direction?');
        
        if ~strcmp(action, 'rest') && strcmp(action, lastAction) % need action twice to enact
            [traj, timesteps]  = determineTraj(action);

            % Move Robot
            if ~isempty(traj)
                disp('Moving');
                curJoints = robai.move(traj, timesteps); 
                if strcmp(action, 'release')
                    organsMoved(organ) = 1;
                    pause(2);
                end
            end
        else
            pause(0.1);        
        end
        lastAction = action;
    end
end

disp('GAME OVER');
robai.goHome(qhome);
pause;
cleanup;
