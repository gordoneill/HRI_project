function [traj, duration] = determineTraj(action)

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
    case 'release'
end

duration = 0.5;
traj = zeros(4,4);
      