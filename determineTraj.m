function [traj, duration] = determineTraj(action, tool)

switch(action)
    case 'up'
        
    case 'down'
        
    case 'left'
        
    case 'right'
        
    case 'forward'
        
    case 'reverse'
        
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
        duration = 0.5;
        traj = zeros(4,4);
end