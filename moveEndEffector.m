function [ jointAngles, t ] = moveEndEffector(action)

global curPose;
global openWidth;
global curJoints;
global robaiBot;

t = (0:0.05:1)';
rotAngle = pi/8;

jointAngles = curJoints;

% curRPY = curPose.torpy; 
% curRoll = curRPY(1);
 
switch(action)
    case 'rotateIn'
        isrange = isinrange(curJoints(7) + rotAngle, deg2rad(-150), deg2rad(150));
        if (isrange == 0)
            jointAngles(7) = curJoints(7) + rotAngle;
        end
    case 'rotateOut'
        isrange = isinrange(curJoints(7) - rotAngle, deg2rad(-150), deg2rad(150));
        if (isrange == 0)
            jointAngles(7) = curJoints(7) - rotAngle; 
        end
    case 'release'
        jointAngles(8) = openWidth;   
end

% curPose = robaiBot.fkine(jointAngles);

end