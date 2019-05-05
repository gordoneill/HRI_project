global organs;
global commands;
global robaiBot;
global curPose;
global qhome;
global heartTraj;
global stomachTraj;
global brainTraj;
global openWidth;
global gripWidth;

organs = ["heart"; "stomach"; "brain"];

commands = ["up"; "down"; "left"; "right"; "forward"; "reverse";...
    "rotateIn"; "rotateOut"; "rest"; "grip"; "release"];

openWidth = 0.0099;
gripWidth = 0.0005;

%%
links = [   
 		  Revolute('d', 0.17735, 'a', 0,         'alpha', pi/2,  'offset', pi/2)
 		  Revolute('d', 0,       'a', 0.12583,   'alpha', -pi/2, 'offset', 0)
 		  Revolute('d', 0,       'a', 0.11538,   'alpha', pi/2,  'offset', -pi/2)
 		  Revolute('d', 0,       'a', -0.09752,  'alpha', pi/2,  'offset', pi/2)
 		  Revolute('d', 0,       'a', 0.07164,   'alpha', pi/2,  'offset', pi/2)
 		  Revolute('d', 0,       'a', 0,         'alpha', -pi/2, 'offset', -pi/2)
 		  Revolute('d', 0.17252, 'a', 0,         'alpha', 0,     'offset', 0)
        ];

robaiBot =  SerialLink(links, 'name', 'Cyton Gamma 1500', 'manufacturer', 'Robai');
% robaiBot.base = SE3(0, 0, 0)*SE3.Rz(90);
homePose = SE3(0, 0.2, 0.13)*SE3.rpy(0,-180,0);

qHomePlot = robaiBot.ikine(homePose);

qhome = convertRobotAnglestoJointAngles(qHomePlot);
qhome = [qhome(1:7) openWidth];
curPose = homePose;

qHeartLoc = SE3(.25, 0.28, 0.03) * SE3.rpy(0,-180,0);
qLungLoc = SE3(.13, 0.28, 0.03) * SE3.rpy(0,-180,0);
qBrainLoc = SE3(.03, 0.28, 0.03)* SE3.rpy(0,-180,0);

qHeartInitPos = convertRobotAnglestoJointAngles(robaiBot.ikine(qHeartLoc));
qStomachInitPos = convertRobotAnglestoJointAngles(robaiBot.ikine(qLungLoc));
qBrainInitPos = convertRobotAnglestoJointAngles(robaiBot.ikine(qBrainLoc));

% qHeartInitPos = [deg2rad([69, 55, 0, 80, 0, 50, -40]) 0.0099]; 
% qStomachInitPos = [deg2rad([85, 45, 0, 98, 0, 40, -30]) 0.0099];
% qBrainInitPos = [deg2rad([102, 40, 0, 109, 0, 35, -5]) 0.0099];

t = [0:0.1:2]';

heartTraj = jtraj(qhome, qHeartInitPos, length(t));
stomachTraj = jtraj(qhome, qStomachInitPos, length(t));
brainTraj = jtraj(qhome, qBrainInitPos, length(t));