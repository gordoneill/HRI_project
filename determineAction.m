function action = determineAction(trainObj, leapData, myoData)

%% Determine Myo Action
% Extract features and classify
features2D = trainObj.extractfeatures(myoData);
[classDecision, ~] = trainObj.classify(reshape(features2D',[],1));

% Display the resulting class number and name
classNames = trainObj.getClassNames;
myoMovement = classNames{classDecision};

switch (myoMovement)
    case 'Wrist Extend Out'
        myoAction = 'up';
    case 'Wrist Flex In'
        myoAction = 'down';
    case 'Wrist Adduction'
        myoAction = 'left';
    case 'Wrist Abduction'
        myoAction = 'right';
    case 'Wrist Rotate In'
        myoAction = 'rotateIn';
    case 'Wrist Rotate Out'
        myoAction = 'rotateOut';
    case 'Hand Open'
        myoAction = 'release';
    case 'Spherical Grasp'
        myoAction = 'grip';
    otherwise
        myoAction = 'rest';
end

%% Determine Leap Action
if isfield(leapData, 'hand')
    numHands          = leapData.hands;
    typicalFingers    = {'Thumb', 'Index', 'Middle', 'Ring', 'Pinky'};
    typicalNumFingers = length(typicalFingers);
    forwardFingers    = {'Index'};
    reverseFingers    = {'Thumb', 'Pinky'};
%     rotateInFingers   = {'Thumb', 'Index', 'Pinky'};
%     rotateOutFingers  = {'Thumb', 'Index'};
    angleDegreeThresh = containers.Map(typicalFingers,{35, 25, 25, 25, 40});
    fingersOut        = containers.Map(typicalFingers,{0, 0, 0, 0, 0});

    % decode leap data
    for curHand = 1:numHands
        numFingers = leapData.fingers;
        if numFingers ~= typicalNumFingers
            disp('Hand has less than 5 fingers?');
        else
            for curFinger = 1:numFingers
                fingerName = leapData.hand(curHand).finger(curFinger).name;
                
                if strcmp(fingerName, 'Thumb')
                    curAngle = LinAlg.Anglebetween( ...
                        leapData.hand(curHand).finger(curFinger).bone(3).direction.', ...
                        leapData.hand(curHand).finger(2).bone(1).direction.');
                    
                    fingersOut(fingerName) = (curAngle > angleDegreeThresh(fingerName));
                else
                    curAngle = LinAlg.Anglebetween( ...
                        leapData.hand(curHand).finger(curFinger).bone(1).direction.', ...
                        leapData.hand(curHand).finger(curFinger).bone(2).direction.');
                    
                    fingersOut(fingerName) = (curAngle < angleDegreeThresh(fingerName));
                end
                
                
            end
        end
    end

    % Interpret leap action
    for curHand = 1:numHands
        fingerOutList = {};
        leapAction = 'rest';
        
        for finger = 1:typicalNumFingers
            if fingersOut(typicalFingers{finger})
                fingerOutList{end + 1} = typicalFingers{finger};
            end
        end
        
        if listsMatch(forwardFingers, fingerOutList)
            leapAction = 'forward'; 
            break;
        elseif listsMatch(reverseFingers, fingerOutList)
            leapAction = 'reverse';
            break;
%         elseif listsMatch(rotateInFingers, fingerOutList)
%             leapAction = 'rotateIn';
%             break;
%         elseif listsMatch(rotateOutFingers, fingerOutList)
%             leapAction = 'rotateOut';
%             break;
        end
    end
else
    leapAction = 'rest';
end

%% Return Game Action
if strcmp(leapAction, 'rest')
    action = myoAction;
else
    action = leapAction;
end

disp(['Action: ' action]);
