global tools;
global commands;
global robaiBot;
global curPose;
global qhome;
global toolWidth; 


tools = ["wrench"; "tweezers"; "scalpel"; "knife"; "probe"];
toolWidth = [2.5; 3; 4; 1.5; 2];
commands = ["up"; "down"; "left"; "right"; "forward"; "reverse";...
    "rotateIn"; "rotateOut"; "rest"; "grip"; "release"];

%% DH Parameters were found using DHFactor function
% s = 'Tz(L1).Rz(q1).Tz(L2).Rx(q2).Ty(L3).Rz(q3).Tx(L4).Ry(q4).Tz(L5).Rx(q5).Ty(L6).Rz(q6).Ty(L7).Ry(q7)';
% dh = DHFactor(s);
% cmd = dh.command('robai');
% robaiBot = eval(cmd);
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

curPose = SE3(0, 0.2, 0.1)*SE3.rpy(0,-180,0,'deg');
qHomePlot = robaiBot.ikine(curPose);
%robaiBot.plot(qHomePlot, 'tilesize', 1)
%xlim([-1, 1])
%ylim([-1, 1])
%zlim([-1, 1])

qhome = convertRobotAnglestoJointAngles(qHomePlot);