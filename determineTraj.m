function [traj, timesteps] = determineTraj(action, tool)

isMove = false;

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
        pol = -1;
    case 'right'
        isMove = true;
        axis = 'x';
        pol = 1;
    case 'forward'
        isMove = true;
        axis = 'y';
        pol = 1;
    case 'reverse'
        isMove = true;
        axis = 'y';
        pol = -1;
    case 'rotateIn'
    case 'rotateOut'
    case 'rest'
    case 'grip'
    case 'release'
        
    otherwise
        error('Unsupported move');
        traj = []; 
        timesteps = [];
        return; 
end

if (isMove)
    % returns array of end effector positions to get to trajectory
    [traj, timesteps ] = move1D(axis, pol); 
else
    [traj, timesteps] = moveEndEffector(action, tool);
end

end 