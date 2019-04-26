global tools;
global commands;
global robaiBot;
global curPose;
global qhome;

tools = ["wrench"; "tweezers"; "scalpel"; "knife"; "probe"];

commands = ["up"; "down"; "left"; "right"; "forward"; "reverse";...
    "rotateIn"; "rotateOut"; "rest"; "grip"; "release"];

links = [   
            Revolute('d', 0.17735, 'a', 0, 'alpha', pi/2) % 0.17735 = distance(L1-L0)
            Revolute('d', 0, 'a', 0.24212, 'alpha', 0) % 0.24212 = distance(L3-L1)
            Revolute('d', 0, 'a', 0.26, 'alpha', 0) % 0.34168 = distance(end - L3)
            Revolute('d', 0, 'a', 0.12, 'alpha', 0)
        ];

robaiBot =  SerialLink(links, 'name', 'Cyton Gamma 1500', 'manufacturer', 'Robai');

curPose = SE3(0, 0.396, 0.1)*SE3.rpy(0,0,0,'deg');
qHomePlot = robaiBot.ikine(curPose, 'mask', [1 1 1 0 0 1]);
qhome = convertRobotAnglestoJointAngles(qHomePlot);