function trainObj = train(path)

% Load training data file
hData = PatternRecognition.TrainingData();
hData.loadTrainingData(path);
 
% Create LDA Classifier Object
trainObj = SignalAnalysis.Lda;
trainObj.initialize(hData);
trainObj.train();
trainObj.computeError();