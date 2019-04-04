function operation()

%% Init Game
tool = initGame();
robai = construct(zeros(1,6));
robai.goHome();
action = 'rest';

while ~strcmp(action, 'release')
    %% Collect Data
    myoData  = collectMyoData();
    leapData = collectLeapData();

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
