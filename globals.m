global tools;
global commands;
global robaiBot;
global curPose;
global mins;
global maxs;
global qhome;

tools = ["wrench"; "tweezers"; "scalpel"; "knife"; "probe"];

commands = ["up"; "down"; "left"; "right"; "forward"; "reverse";...
    "rotateIn"; "rotateOut"; "rest"; "grip"; "release"];

links = [   
            Revolute('d', 0.2, 'a', 0, 'alpha', pi/2) % 0.17735 = distance(L1-L0)
            Revolute('d', 0, 'a', 0.255, 'alpha', 0) % 0.24212 = distance(L3-L1)
            Revolute('d', 0, 'a', 0.26, 'alpha', 0) % 0.34168 = distance(end - L3)
            Revolute('d', 0, 'a', 0.12, 'alpha', 0)
    
% 		  Revolute('d', 0.74, 'a', 0, 'alpha', pi/2)
% 		  Revolute('d', 0, 'a', 1.0335, 'alpha', pi/2)
% 		  Revolute('d', 0, 'a', 1.2583, 'alpha', pi/2)
% 		  Revolute('d', 0, 'a', 1.1538, 'alpha', pi/2)
% 		  Revolute('d', 0, 'a', 0.9752, 'alpha', pi/2)
% 		  Revolute('d', 0, 'a', 0.7164, 'alpha', -pi/2) %0.7164
% 		  Revolute('d', 0, 'a', 0, 'alpha', pi) %1.7252
          
        ];
robaiBot =  SerialLink(links, 'name', 'Cyton Gamma 1500', 'manufacturer', 'Robai');
% robaiBot.base = transl(0,0,0.15); %*rpy2tr(0, 0, -pi/2);

qz = [0 pi/2 0 0];% 0 0 0 0];
% qhome = [0  pi/2 pi/3 pi/3]; % 0 0 0];
deg = pi/180;

curPose = SE3(0, 0.209, 0.1)*SE3.rpy(0,0,0,'deg');
qhome = robaiBot.ikine(curPose, 'mask', [1 1 1 0 0 1]);

mins = [  0 -15  -105 -105]*deg; 
maxs = [180  90  105  105]*deg;

%robaiBot.plot(qhome, 'tilesize', 1)
% xlim([-1, 1])
% ylim([-1, 1])
% zlim([-1, 1])
