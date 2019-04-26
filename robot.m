classdef robot < handle
    % robai robotic arm
    properties
        jointAngles
        actin
        unity
        numJoints = 8;
        homeValues = [0 0 0 0 0 0 0 0];
    end
    
    methods
        %% Constructor
        function obj = robot(actinIn, unityIn)
            obj.actin       = actinIn;
            obj.unity       = unityIn;
            obj.jointAngles = obj.homeValues;
        end
        
        %% Function to go to home angles
        function [success] = goHome(robai, qHome)
            robai.jointAngles = qHome;
            success = robai.sendCommand(robai.jointAngles);
        end
        
        %% Function to move robot in a trajectory
        function [success] = move(robai, traj, timesteps)
            timediff = timesteps(2) - timesteps(1);
            for step = 1:size(traj, 2)
                disp("Moving");
                robai.jointAngles = traj(step, :);
                success = robai.sendCommand(robai.jointAngles);
                pause(timediff);
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
            success = 1;
            robai.unity.putData(typecast(single(...
                    [rad2deg(jointAngles(1:7)), jointAngles(8)]), 'uint8')); 
        end
    end
end