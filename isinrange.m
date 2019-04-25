function [isRange] = isinrange(val, min, max)
% returns 0 if in range
% returns -1 if below min
% returns 1 if above max 

if (val <= min)
    isRange = -1;
elseif (val >= max)
   isRange = 1; 
else
   isRange = 0;
end

end

