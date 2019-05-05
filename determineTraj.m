function [traj, timesteps] = determineTraj(action)

switch(action)
    case 'up'
        isMove = true;
        axis = 'z';
        pol = 1;
    case 'down'
        isMove = true;
        axis = 'z';
        pol = -1;
    case 'left'
        isMove = true;
        axis = 'x';
        pol = 1;
    case 'right'
        isMove = true;
        axis = 'x';
        pol = -1;
    case 'forward'
        isMove = true;
        axis = 'y';
        pol = -1;
    case 'reverse'
        isMove = true;
        axis = 'y';
        pol = 1;
    case 'rotateIn'
        isMove = false;
    case 'rotateOut'
        isMove = false;
    case 'rest'
        isMove = false;
    case 'release'
        isMove = false;
    otherwise
        error('Unsupported move');
end

if (isMove)
    % returns array of end effector positions to get to trajectory
    [traj, timesteps] = move1D(axis, pol); 
else
    [traj, timesteps] = moveEndEffector(action);
end

end 