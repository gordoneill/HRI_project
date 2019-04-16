global tools;
global robaiBot;

tools = ["wrench"; "tweezers"; "scalpel"; "knife"; "probe"];

links = [     
		  Revolute('d', 0.74, 'a', 0, 'alpha', pi/2)
		  Revolute('d', 0, 'a', 1.0335, 'alpha', pi/2)
		  Revolute('d', 0, 'a', 1.2583, 'alpha', pi/2)
		  Revolute('d', 0, 'a', 1.1538, 'alpha', pi/2)
		  Revolute('d', 0, 'a', 0.9752, 'alpha', pi/2)
		  Revolute('d', 0, 'a', 0, 'alpha', pi/2) %0.7164
		  Revolute('d', 0, 'a', 0, 'alpha', 0) %1.7252
        ];
robaiBot =  SerialLink(links, 'name', 'Cyton Gamma 1500', 'manufacturer', 'Robai');
%robaiBot.base = SE3(2, 1, 0);
dest = robaiBot.ikine(SE3(2.31, 1.33, 0.0497)*SE3.Rx(-pi/6)*SE3.Rz(pi));

robaiBot.plot(dest)