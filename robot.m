classdef robot < handle
    % robai robotic arm
    
    properties
        jointAngles
        actin
        unity
        numJoints = 8;
        homeValues = [0 pi/4 0 pi/2 0 pi/2 0 0.01];
    end
    
    methods
        %% Constructor
        function obj = robot(actinIn, unityIn)
            obj.actin       = actinIn;
            obj.unity       = unityIn;
            obj.jointAngles = obj.homeValues;
        end
        
        %% Function to go to home angles
        function [success] = goHome(robai)
            robai.jointAngles = robai.homeValues;
            success = sendCommand(robai.jointAngles);
        end
        
        %% Function to move robot in a trajectory
        function [success] = move(robai, traj)
            timeStep = size(traj, 2) / duration;
            for step = 1:size(traj, 2)
                robai.jointAngles = traj(step);
                success = sendCommand(robai.jointAngles);
                sleep(timeStep);
            end
        end
        
        %% Function to move specific robot joint
        function [success] = moveJoint(robai, jointAngle, joint)
            robai.jointAngles(joint) = jointAngle;
            success = sendCommand(robai.jointAngles);
        end
        
        %% Function to grip robot
        function [success] = grip(robai, tool)
            switch(tool)
                case 'tweasers'
                    robai.jointAngles(8) = 5;
                otherwise
                    robai.jointAngles = 0;
            end
            success = sendCommand(robai.jointAngles);
        end
        
        %% Function to send the command
        function [success] = sendCommand(robai, jointAngles)
            %success = robai.actin.putData(typecast(jointAngles, 'uint8'));
            
            success = ...
                robai.unity.putData(typecast(single(...
                    [rad2deg(jointAngles(1:7)), jountAngles(8)]), 'uint8')); 
        end
    end
end

