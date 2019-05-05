function  [ jointAngles, t ] = move1D(axis, pol) 
%axis will contain x, y, or z (in the world frame
%pol will contain the polarity to move (1 or -1)

% Here we define the limits in the world frame of the arm
global robaiBot; 
global curPose;
global curJoints;

deg = pi/180;
% Joint ranges
mins = [-150 -15 -15 -15 -15 -105 -150]*deg; 
maxs = [ 150 195 195 195 195  105  150]*deg;
jointAngles = [];

% Create the trajectory 
st = 0.1;
t = [0:st:0.5]';

% Cartesian space ranges
zrange = [0.06  0.13]; 
radLims = [0.15 0.3944];
xyDist = 0.05; % 5 cm
zDist = zrange(2) - zrange(1); %Must fluctuate between 0.02m and 0.1m

switch(axis)
    case 'x'
        destX = curPose.t(1) - (pol*xyDist); 
        rad = sqrt((destX^2) + (curPose.t(2)^2));
        isRadRange = isinrange(rad, radLims(1), radLims(2));

        if isRadRange == -1
            newX = sqrt(radLims(1)^2 - curPose.t(2)^2);
            dist = newX - abs(curPose.t(1));
        elseif isRadRange == 1
            newX = sqrt(radLims(2)^2 - curPose.t(2)^2);
            dist = newX - abs(curPose.t(1));
        else 
            dist = xyDist;
        end 
        
        translation = SE3(pol*dist, 0, 0);
    case 'y'
        destY = curPose.t(2) + (pol*xyDist); 
        rad = sqrt((destY^2) + (curPose.t(1)^2));
        isRadRange = isinrange(rad, radLims(1), radLims(2));

        if isRadRange == -1
            newY = sqrt(radLims(1)^2 - curPose.t(1)^2);
            dist = newY - abs(curPose.t(2));
        elseif isRadRange == 1
            newY = sqrt(radLims(2)^2 - curPose.t(1)^2);
            dist = newY - abs(curPose.t(2));
        else
            dist = xyDist;
        end 
        
        translation = SE3(0, pol*dist, 0);        
    case 'z'
        if (((pol == 1) && (curPose.t(3) == zrange(1))) || ((pol == -1) && (curPose.t(3) == zrange(2))))
            translation = SE3(0, 0, -1*pol*zDist);  
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

if (translation == SE3(0, 0, 0))
    fprintf("Reached axis %s limit.\n", axis);
    return;
end

destPose = curPose * translation;

dest = robaiBot.ikine(destPose);

% Check joint angle ranges 
for i=1:length(dest)
    isRange = isinrange(dest(i), mins(i), maxs(i));
    if isRange == 1
        fprintf("Joint angle %d exceeds limits. Is %d, cannot be greater than %d\n", i, dest(i), maxs(i));
%         if (i ~= length(dest))
%             dest(i+1) = dest(i+1) + (dest(i) - mins(i));
%         end
        dest(i) = maxs(i);
    elseif isRange == -1
        fprintf("Joint angle %d exceeds limits. Is %d, cannot be less than %d\n", i, dest(i), mins(i));
%         if (i ~= length(dest))
%              dest(i+1) = dest(i+1) + (dest(i) - mins(i));
%         end
        dest(i) = mins(i);
    end
end

poses = curPose.interp(destPose, tpoly(0, 1, t));
% disp(destPose);
if (length(dest) ~= 7)
    disp('Unable to compute trajectory'); 
else
    angles = zeros(length(dest), length(poses));

    for i=1:length(poses)
         curAngles = robaiBot.ikine(poses(i));
         if (isempty(curAngles))
            angles(:, i) = angles(:,i); 
         end
         angles(:, i) = curAngles;
    end
    
    jointAngles = convertRobotAnglestoJointAngles(angles);
    jointAngles(:,7) = curJoints(7);
    curPose = destPose;
end 
end

