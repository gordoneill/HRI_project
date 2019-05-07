function [jointAngles] = convertRobotAnglestoJointAngles(robotAngles)
global gripState;
[len, wid] = size(robotAngles);
numVecs = 0;
%one dimension should be 7. the other determines the number of vectors we
%want to modify
if len == 7
    numVecs = wid; 
    robotAngles = robotAngles.';
elseif wid == 7
    numVecs = len;
else
    error("Invalid input. One dimension of array must equal 7");
    return;
end

%% Make changes to angle values to correspond to actual joint angles 
robotAngles(:, 1) = robotAngles(:, 1) - 1.1439;
robotAngles(:, 2:5) = robotAngles(:, 2:5) - (pi/2);
% robotAngles(:, 6) = -1*robotAngles(:, 6);
% robotAngles(:, 7) = -1*robotAngles(:, 4);

%% Create vector for joint angles
jointAngles = zeros(numVecs, 8);

jointAngles(:, 1:7) = robotAngles(:, 1:7);
jointAngles(:, 8) = gripState;
end

