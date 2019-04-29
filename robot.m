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
        function [success] = goHome(robai, qHome, curPose)
            st = 0.1;
            t = [0:st:0.5]';
            destPose = robaiBot.fkine(qHome);
            poses = curPose.interp(destPose, tpoly(0, 1, t));
            angles = zeros(length(qHome), length(poses));
            for i=1:length(poses)
                 curAngles = robaiBot.ikine(poses(i));
                 if (isempty(curAngles))
                    angles(:, i) = angles(:,i); 
                 end
                 angles(:, i) = curAngles;
            end
            % disp(angles);
            jointAngles = convertRobotAnglestoJointAngles(angles);
            success = robai.move(jointAngles, t);
        end
        
        %% Function to move robot in a trajectory
        function [success] = move(robai, traj, timesteps)
            timediff = timesteps(2) - timesteps(1);
            for step = 1:size(traj, 1)
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