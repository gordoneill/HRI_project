function grabOrgan(organ, t, robot)

global heartTraj;
global stomachTraj;
global brainTraj;
global qhome;
global gripWidth;
global curJoints;
global openWidth;

% Move to organ location
switch(organ)
    case 'heart'
        angles = heartTraj;
    case 'stomach'
        angles = stomachTraj; 
    case 'brain'
        angles = brainTraj;
end 
angles(:,8) = openWidth;
robot.move(angles, t);
pause(5)
% Grab piece 
curAngles = angles(length(angles), :);

curAngles = [curAngles(1:7) gripWidth];
robot.sendCommand(curAngles);
pause(2)
% Return to home 
angles(:, 8) = gripWidth;
% returnAngles = flip(angles);

startAngles = angles(end, :);
raisedAngles = startAngles;
raisedAngles(2) = qhome(2);
raisedAngles(6) = raisedAngles(6) + deg2rad(10);

via = [startAngles; raisedAngles; [qhome(1:7) gripWidth]];

[s, ~, ~] = mstraj(via, [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1], [], via(1, :), (t(2) - t(1)), 0.2);
numsteps = length(s); 
st = 3/numsteps;
times = (0:st:3-st)';
curJoints = robot.move(s, times);
pause(1);

end

