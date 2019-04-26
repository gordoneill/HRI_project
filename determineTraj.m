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
        pol = 1;
    case 'right'
        isMove = true;
        axis = 'x';
        pol = -1;
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
        switch(tool)
            case 'heart'
            case 'lung'
            case 'liver'
        end
    case 'release'
        
    otherwise
        error('Unsupported move');
end

if (isMove)
    % returns array of end effector positions to get to trajectory
    [traj, timesteps ] = move1D(axis, pol); 
end

end 