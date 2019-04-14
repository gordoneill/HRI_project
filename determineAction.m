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
disp(leapData);

%% Return Game Action
if strcmp(leapAction, 'rest')
    action = myoAction;
else
    action = leapAction;
end
