function [leapData] = collectLeapData()

leapData = h.getData();   

if isempty(leapData) || leapData.hands == 0
    error('Leap data failed');
end