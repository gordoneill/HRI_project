function [myo,leap,actin,unity] = initExternalDevices()

addpath(pwd);
addpath('C:\GitHub\MiniVIE');
MiniVIE.configurePath;

% % Init Myo class
UserConfig.getInstance('C:\GitHub\MiniVIE\user_config.xml')
myo = Inputs.MyoUdp.getInstance();
myo.initialize();
%system('C:\GitHub\MiniVIE\+Inputs\MyoUdp.exe');
% 
% % Init Leap class
leap = Inputs.LeapMotion;
leap.initialize();
%system('C:\GitHub\hrilabs\Lab4_FingerControl\StartLeapStream.bat');

% % Init Actin Viewer
actin = PnetClass(8889, 8888, '127.0.0.1');
actin.initialize();
%system('C:\GitHub\MiniVIE\activ.exe');

% % Init Unity vCyton
unity = PnetClass(12002, 12001, '127.0.0.1');
unity.initialize();
%system('C:\GitHub\MiniVIE\unity.exe');