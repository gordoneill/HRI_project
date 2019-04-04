function [myoData] = collectMyoData(myo)

myoData = myo.getData();

if isempty(myo.Orientation)    
    error('Myo data failed');
end