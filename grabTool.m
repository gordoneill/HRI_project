function grabTool(tool, t, robot)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

global heartTraj;
global stomachTraj;
global brainTraj;
global qhome;

% Move to tool location
switch(tool)
    case 'heart'
        angles = heartTraj;
    case 'stomach'
        angles = stomachTraj; 
    case 'brain'
        angles = brainTraj;
end 
robot.move(angles, t);
pause(2)
% Grab piece 
curAngles = angles(length(angles), :);

curAngles = [curAngles(1:7) 0.0005];
robot.sendCommand(curAngles);
pause(2)
% Return to home 
angles(:, 8) = 0.0005;
% returnAngles = flip(angles);

startAngles = angles(end, :);
raisedAngles = startAngles;
raisedAngles(2) = qhome(2);
raisedAngles(6) = raisedAngles(6) + deg2rad(10);

via = [startAngles; raisedAngles; [qhome(1:7) 0.0005]];

[s, sd, sdd] = mstraj(via, [0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1], [], via(1, :), (t(2) - t(1)), 0.2);
numsteps = length(s); 
st = 3/numsteps;
times = [0:st:3-st]';
robot.move(s, times);
pause(1)
end

