function action = determineAction(trainObj, leapData, myoData)

% Extract features and classify
features2D = trainObj.extractfeatures(myoData);
[classDecision, ~] = trainObj.classify(reshape(features2D',[],1));

% Display the resulting class number and name
classNames = trainObj.getClassNames;
className = classNames{classDecision};
fprintf('Class=%2d; Class = %16s;\n',classDecision,className);

action = className;

end