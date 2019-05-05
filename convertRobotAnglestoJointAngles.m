function [jointAngles] = convertRobotAnglestoJointAngles(robotAngles)
[len, wid] = size(robotAngles);
numVecs = 0;
%one dimension should be 4. the other determines the number of vectors we
%want to modify
if len == 4
    numVecs = wid; 
    robotAngles = robotAngles.';
elseif wid == 4
    numVecs = len;
else
    error("Invalid input. One dimension of array must equal 4");
    return;
end

%% Make changes to angle values to correspond to actual joint angles 
robotAngles(:, 1) = robotAngles(:, 1) + deg2rad(-200);
robotAngles(:, 2) = (pi/2) - robotAngles(:, 2);
robotAngles(:, 3) = -1*robotAngles(:, 3);
robotAngles(:, 4) = -1*robotAngles(:, 4);

%% Create vector for joint angles
jointAngles = zeros(numVecs, 8);

jointAngles(:, 1:2) = robotAngles(:, 1:2);
jointAngles(:, 4) = robotAngles(:, 3);
jointAngles(:, 6) = robotAngles(:, 4);
jointAngles(:, 8) = 0.005;
end

