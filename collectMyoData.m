function [myoData] = collectMyoData(myo, trainObj)

myoData = myo.getData(trainObj.NumSamplesPerWindow,1:8);

if isempty(myo.Orientation)    
    error('Myo data failed');
end