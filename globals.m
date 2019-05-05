global tools;
global commands;
global robaiBot;
global curPose;
global qhome;
global heartTraj;
global stomachTraj;
global brainTraj;

tools = ["heart"; "stomach"; "brain"];

commands = ["up"; "down"; "left"; "right"; "forward"; "reverse";...
    "rotateIn"; "rotateOut"; "rest"; "grip"; "release"];

%% DH Parameters were found using DHFactor function
% s = 'Tz(L1).Rz(q1).Tz(L2).Rx(q2).Ty(L3).Rz(q3).Tx(L4).Ry(q4).Tz(L5).Rx(q5)....
%   Ty(L6).Rz(q6).Ty(L7).Ry(q7)';
% dh = DHFactor(s);
% cmd = dh.command('robai');
% robaiBot = eval(cmd);
%%
links = [   
            Revolute('d', 0.17735, 'a', 0, 'alpha', pi/2) % 0.17735 = distance(L1-L0)
            Revolute('d', 0, 'a', 0.24212, 'alpha', 0) % 0.24212 = distance(L3-L1)
            Revolute('d', 0, 'a', 0.26, 'alpha', 0) % 0.34168 = distance(end - L3)
            Revolute('d', 0, 'a', 0.12, 'alpha', 0)
        ];

robaiBot =  SerialLink(links, 'name', 'Cyton Gamma 1500', 'manufacturer', 'Robai');
% robaiBot.base = SE3.Rz(deg2rad(-111));

curPose = SE3(0, 0.3, 0.13)*SE3.rpy(0,0,0,'deg'); %0.396

qHomePlot = robaiBot.ikine(curPose, 'mask', [1 1 1 0 0 1]);

qhome = convertRobotAnglestoJointAngles(qHomePlot);

qHeartInitPos = [deg2rad([-149, 55, 0, 80, 0, 50, -40]) 0.0099]; 
qStomachInitPos = [deg2rad([-135, 45, 0, 98, 0, 40, -30]) 0.0099];
qBrainInitPos = [deg2rad([-114, 40, 0, 109, 0, 35, -5]) 0.0099];

% qHeartLoc = SE3(.03, 0.28, 0.055);
% qLungLoc = SE3(.13, 0.28, 0.055);
% qBrainLoc = SE3(.25, 0.28, 0.055);
t = [0:0.1:2]';
% poses = curPose.interp(qHeartLoc, tpoly(0, 1, t));

heartTraj = jtraj(qhome, qHeartInitPos, length(t));
stomachTraj = jtraj(qhome, qStomachInitPos, length(t));
brainTraj = jtraj(qhome, qBrainInitPos, length(t));
% for i=1:length(poses)
%     qHeartTraj(:,i) = robaiBot.ikine(poses(i), 'mask', [1 1 1 0 0 1]);
% end

% qLungJointAngles = robaiBot.ikine(qLungLoc, 'mask', [1 1 1 0 0 1]);
% qBrainJointAngles = robaiBot.ikine(qBrainLoc, 'mask', [1 1 1 0 0 1]);

