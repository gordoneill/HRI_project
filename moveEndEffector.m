function [ jointAngles, t ] = moveEndEffector(action, tool)

global tools;
global curPose;
global robaiBot; 

t = (0:0.05:1)';
rotAngle = pi/8;
jointAngles = robaiBot.ikine(curPose);

curRPY = curPose.torpy; 
curRoll = curRPY(1);
openWidth = 0.09; 

switch(action)
    case 'rotateIn'
        jointAngles(7) = curRoll + rotAngle; 
    case 'rotateOut'
        jointAngles(7) = curRoll - rotAngle;  
    case 'grip'
        %% Define width based on tool selected
        width = 0.002;
        % need to keep track of current width? should be openWidth...
        jointAngles(8) = width;
    case 'release'
        jointAngles(8) = openWidth;   
end

end