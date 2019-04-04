function operation()

%% Init Game
% Init Myo class
myo = Inputs.MyoUdp.getInstance();
myo.initialize()
% Init Leap class
leap = Inputs.LeapMotion;
leap.initialize();

tool = initGame();
robai = construct(zeros(1,6));
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
