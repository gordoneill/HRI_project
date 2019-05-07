function [ jointAngles, t ] = moveEndEffector(action)

global openWidth;
global curJoints;
global gripWidth;
global gripState; 

t = (0:0.05:1)';
rotAngle = pi/8;

jointAngles = curJoints;
 
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
        gripState = openWidth;
    case 'grip'
        jointAngles(8) = gripWidth; 
        gripState = gripWidth;
end

end