function  traj = move1D(axis, pol, curPose)
%axis will contain x, y, or z (in the world frame
%pol will contain the polarity to move (1 or -1)
%curPose contains the current pose of the end effector 

% Here we define the limits in the world frame of the arm
xrange = [-10 10];
yrange = [-10 10];
zrange = [-10 10]; 

switch(axis)
    case 'x'
        translation = SE3(pol*2, 0, 0);
    case 'y'
        translation = SE3(0, pol*2, 0);        
    case 'z'
        translation = SE3(0, 0, pol*2);
    otherwise
        disp("Invalid input.");
        return;
end
destPose = curPose * translation;

% need to check that this is within bounds
[ex, why, zee] = transl(destPose);
if ((ex < xrange(1)) || (ex > xrange(2)) || ...
    (why < yrange(1)) || (why > yrange(2)) || ...
    (zee < zrange(1)) || (zee > zrange(2)))
    disp("Out of range. Cannot move to desired location");
end

% create trajectory
t = [0:0.1:4]';
traj = curPose.interp(destPose, tpoly(0, 1, t));

%tranimate(traj)

end

