function [myo,leap,actin,unity] = initExternalDevices()

% Init Myo class
myo = Inputs.MyoUdp.getInstance();
myo.initialize()
% Init Leap class
leap = Inputs.LeapMotion;
leap.initialize();
% Init Actin Viewer
actin = PnetClass(8889, 8888, '127.0.0.1');
actin.initialize();
% Init Unity vCyton
unity = PnetClass(12002, 12001, '127.0.0.1');
unity.initialize();

