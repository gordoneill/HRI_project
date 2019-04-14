function [leapData] = collectLeapData(leap)

leapData = leap.getData();  

if isempty(leapData)    
    error('Leap data failed');
end