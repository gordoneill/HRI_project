classdef robot < handle
    % robai robotic arm
    
    properties
        jointAngles
        numJoints = 6;
        homeValues = [1, 2, 3, 4, 5, 6];
    end
    
    methods
        %% Constructor
        function robai = construct(jointAngles)
            robai.jointAngles = jointAngles;
        end
        
        %% Function to go to home angles
        function [success] = goHome(robai)
            robai.jointAngles = robai.homeValues;
            success = sendCommand(robai.jointAngles);
        end
        
        %% Function to move robot in a trajectory
        function [success] = move(robai, traj, duration)
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
                    robai.jointAngles(6) = 5;
                otherwise
                    robai.jointAngles = 0;
            end
            success = sendCommand(robai.jointAngles);
        end
        
        %% Function to send the command
        function [success] = sendCommand(jointAngles)
            send(jointAngles);
            success = 1;
        end
    end
end

