function  [ jointAngles, t ] = move1D(axis, pol) 
%axis will contain x, y, or z (in the world frame
%pol will contain the polarity to move (1 or -1)
%curPose contains the current pose of the end effector 

% Here we define the limits in the world frame of the arm
global robaiBot; 
global curPose;
global maxs;
global mins;
jointAngles = [];
xrange = [-0.390 0.390];
yrange = [0 0.390];
zrange = [0.02  0.1]; 
radLims = [0.209 0.390];
xyDist = 0.05; % 5 cm
zDist = 0.08; %Must fluctuate between 0.02m and 0.1m

switch(axis)
    case 'x'
        destX = curPose.t(1) + (pol*xyDist); 
        rad = sqrt(destX^2 + curPose.t(2)^2);
        if (destX < xrange(1))
            dist = curPose.t(1) - xrange(1); 
        elseif  (destX > xrange(2))
            dist = xrange(2) - curPose.t(1); 
        elseif (rad < radLims(1))
            newX = sqrt(radLims(1)^2 - curPose.t(2)^2);
            dist = newX - curPose.t(1);
        elseif (rad > radLims(2))
            newX = sqrt(radLims(2)^2 - curPose.t(2)^2);
            dist = newX - curPose.t(1);
        else 
            dist = 0;
        end 
        translation = SE3(pol*dist, 0, 0);
    case 'y'
        destY = curPose.t(2) + (pol*xyDist); 
        rad = sqrt(destY^2 + curPose.t(1)^2);

        if (destY < yrange(1))
            dist = curPose.t(2) - yrange(1); 
        elseif  (destY > yrange(2))
            dist = yrange(2) - curPose.t(2); 
        elseif (rad < radLims(1))
            newY = sqrt(radLims(1)^2 - curPose.t(1)^2);
            dist = newY - curPose.t(2);
        elseif (rad > radLims(2))
            newY = sqrt(radLims(2)^2 - curPose.t(1)^2);
            dist = newY - curPose.t(2);
        end 
        translation = SE3(0, pol*dist, 0);        
    case 'z'
        if (((pol == 1) && (curPose.t(3) == zrange(1))) || ((pol == -1) && (curPose.t(3) == zrange(2))))
            translation = SE3(0, 0, pol*zDist);  
        else
            if (pol == 1)
               fprintf("Cannot go up. Already at up position.\n");
            else
               fprintf("Cannot go down. Already at down position.\n");
            end
            return;
        end
        
    otherwise
        disp("Invalid input.");
        return;
end
destPose = curPose * translation;

start = robaiBot.ikine(curPose, 'mask', [1 1 1 0 0 1]);
dest = robaiBot.ikine(destPose, 'mask', [1 1 1 0 0 1]);

% Check joint angle ranges 
for i=1:length(dest)
    if (dest(i) > maxs(i))
        fprintf("Joint angle %d exceeds limits. Is %d, cannot be greater than %d\n", i, dest(i), maxs(i));
        if (i ~= length(dest))
            dest(i+1) = dest(i+1) + (dest(i) - mins(i));
        end
        dest(i) = maxs(i);
    elseif (dest(i) < mins(i))
        fprintf("Joint angle %d exceeds limits. Is %d, cannot be less than %d\n", i, dest(i), mins(i));
        if (i ~= length(dest))
             dest(i+1) = dest(i+1) + (dest(i) - mins(i));
        end
        dest(i) = mins(i);
    end
end

% Create the trajectory 
st = 0.5;
t = [0:st:4]';


poses = curPose.interp(destPose, tpoly(0, 1, t));
%robaiBot.plot(traj)
angles = zeros(length(dest), length(poses));

for i=1:length(poses)
     %Send joint angles to bot in steps
     %Want each move to take ~4 seconds
     %each step ~0.1 seconds (st) 
    angles(:, i) = robaiBot.ikine(poses(i), 'mask', [1 1 1 0 0 1]);

%     success = robai.unity.putData(typecast(single(...
%               [rad2deg(jointAngles(1:7)), jointAngles(8)]), 'uint8')); 
%     if (~success)
%         disp("Failed to put data on robai");
%     end
%     pause(st);
end
jointAngles = zeros(8,length(poses));

jointAngles(1:2,:) = angles(1:2, :);
jointAngles(4,:) = angles(3, :);
jointAngles(6,:) = angles(4, :);
end
