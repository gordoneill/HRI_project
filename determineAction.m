function action = determineAction(trainObj, leapData, myoData)

%% Determine Myo Action
% Extract features and classify
features2D = trainObj.extractfeatures(myoData);
[classDecision, ~] = trainObj.classify(reshape(features2D',[],1));

% Display the resulting class number and name
classNames = trainObj.getClassNames;
myoMovement = classNames{classDecision};

switch (myoMovement)
    case 'Wrist Inflection'
        myoAction = 'up';
    case 'Wrist Extension'
        myoAction = 'down';
    case 'Wrist Adduction'
        myoAction = 'left';
    case 'Wrist Abduction'
        myoAction = 'right';
    case 'No Movement'
        myoAction = 'rest';
    case 'Hand Open'
        myoAction = 'release';
    case 'Spherical Grasp'
        myoAction = 'grip';
    otherwise
        myoAction = 'rest';
end

disp(myoAction);

%% Determine Leap Action
if isfield(leapData, 'hand')
    numHands          = length(leapData.hand);
    typicalNumFingers = 5;
    forwardFingersR   = [0 1 0 0 0];
    forwardFingersL   = [0 0 0 1 0];
    reverseFingers    = [1 0 0 0 1];
    rotateInFingers   = [1 0 0 1 1];
    rotateOutFingers  = [1 1 0 0 1];
    angleDegreeThresh = [5 25.0];
    fingersOut        = zeros(numHands, typicalNumFingers);

    % decode leap data
    for curHand = 1:numHands
        numFingers = length(leapData.hand(curHand).finger);
        if numFingers ~= typicalNumFingers
            disp('Hand has less than 5 fingers?');
        else
            for curFinger = 1:numFingers
                curAngle = LinAlg.Anglebetween( ...
                    leapData.hand(curHand).finger(curFinger).bone(2).direction.', ...
                    leapData.hand(curHand).finger(curFinger).bone(3).direction.');
                
                if strcmp(leapData.hand(curHand).finger(curFinger).name, 'Thumb')
                    curAngle = LinAlg.Anglebetween( ...
                        leapData.hand(curHand).finger(curFinger).bone(3).direction.', ...
                        leapData.hand(curHand).finger(curFinger).bone(4).direction.');
                end

                isFingerOut = ((curAngle > angleDegreeThresh(1)) && (curAngle < angleDegreeThresh(2)));
                
                fingersOut(curHand, curFinger) = isFingerOut;
            end
        end
    end

    % Interpret leap action
    for curHand = 1:numHands
        forwardPos   = isequal(fingersOut(curHand, :), forwardFingersR) || ...
                            isequal(fingersOut(curHand, :), forwardFingersL);
        reversePos   = isequal(fingersOut(curHand, :), reverseFingers);
        rotateInPos  = isequal(fingersOut(curHand, :), rotateInFingers);
        rotateOutPos = isequal(fingersOut(curHand, :), rotateOutFingers);

        if forwardPos
            leapAction = 'forward'; 
            break;
        elseif reversePos
            leapAction = 'reverse';
            break;
        elseif rotateInPos
            leapAction = 'rotateIn';
            break;
        elseif rotateOutPos
            leapAction = 'rotateOut';
            break;
        else
            leapAction = 'rest';
        end
    end
else
    leapAction = 'rest';
end

disp(['leap action: ' leapAction]);

%% Return Game Action
if strcmp(leapAction, 'rest')
    action = myoAction;
else
    action = leapAction;
end
