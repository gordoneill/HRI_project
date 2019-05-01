function [ jointAngles, t ] = moveEndEffector(action, tool)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global tools;
global curPose;

t = [0:0.05:1]';
rotAngle = pi/4;
jointAngles = zeros(1, 8);

curRPY = curPose.torpy; 
curRoll = curRPY(1);
openWidth = 5; 

switch(action)
    case 'rotateIn'
        jointAngles(7) = curRoll + rotAngle; 
    case 'rotateOut'
        jointAngles(7) = curRoll - rotAngle;  
    case 'grip'
        %% Define width based on tool selected
        width = 0;
        for i=1:length(tools)
           if strcmp(tool, tools(i))
               width = toolWidth(i);
           end
        end
        % need to keep track of current width? should be openWidth...
        jointAngles(8) = width;
    case 'release'
        jointAngles(8) = openWidth;   
end

end

