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

openWidth = 0.007;
gripWidth = 0.0005;

%%
links = [   
            Revolute('d', 0.17735, 'a', 0, 'alpha', pi/2) % 0.17735 = distance(L1-L0)
            Revolute('d', 0, 'a', 0.24212, 'alpha', 0) % 0.24212 = distance(L3-L1)
            Revolute('d', 0, 'a', 0.26, 'alpha', 0) % 0.34168 = distance(end - L3)
            Revolute('d', 0, 'a', 0.12, 'alpha', 0)
        ];

robaiBot =  SerialLink(links, 'name', 'Cyton Gamma 1500', 'manufacturer', 'Robai');
homePose = SE3(0, 0.3, 0.13); %*SE3.Rx(0); %SE3.rpy(0,0,180,'deg'); %0.396
qHomePlot = robaiBot.ikine(homePose, 'mask', [1 1 1 0 0 1]);
qhome = convertRobotAnglestoJointAngles(qHomePlot);
qhome = [qhome(1:7) openWidth];
curPose = homePose;

qHeartInitPos = [deg2rad([69, 55, 0, 80, 0, 50, -40]) 0.0099]; 
qStomachInitPos = [deg2rad([85, 45, 0, 98, 0, 40, -30]) 0.0099];
qBrainInitPos = [deg2rad([102, 40, 0, 109, 0, 35, -5]) 0.0099];

t = [0:0.1:2]';

heartTraj = jtraj(qhome, qHeartInitPos, length(t));
stomachTraj = jtraj(qhome, qStomachInitPos, length(t));
brainTraj = jtraj(qhome, qBrainInitPos, length(t));