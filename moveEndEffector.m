function [ jointAngles, t ] = moveEndEffector(action, tool)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global tools;
rotAngle = pi/4;
jointAngles = zeros(1, 8);

curAngle = curPose.torpy(3); 
openWidth = 5; 

if (strcmp(action, 'rotateIn'))
    jointAngles(7) = curAngle + rotAngle; 
elseif (strcmp(action, 'rotateOut'))
    jointAngles(7) = curAngle + rotAngle;  
elseif (strcmp(action, 'grip'))
    %% Define width based on tool selected
    width = 0;
    for i=1:length(tools)
       if strcmp(tool, tools(i))
           width = toolWidth(i);
       end
    end
    % need to keep track of current width? should be openWidth...
    jointAngles(8) = width;
elseif (strcmp(action, 'release'))
    jointAngles(8) = openWidth;   
end

end

