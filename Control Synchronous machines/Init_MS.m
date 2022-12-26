clear all
close all
clc

Concordia=sqrt(2/3)*[1 -0.5 -0.5;0 sqrt(3)/2 -sqrt(3)/2;1/sqrt(2) 1/sqrt(2) 1/sqrt(2)];
IConcordia=sqrt(3/2)*[2/3 0 sqrt(2)/3;-1/3 1/sqrt(3) sqrt(2)/3;-1/3 -1/sqrt(3) sqrt(2)/3];
Clarke=[2/3 -1/3 -1/3;0 1/sqrt(3) -1/sqrt(3);1/3 1/3 1/3];
IClarke=[1 0 1;-1/2 sqrt(3)/2 1;-1/2 -sqrt(3)/2 1];
theta=10;
Park=[sin(theta) cos(theta);-sin(theta) cos(theta)];
 
Pn = 800;
In = 1.52;
fn = 50;
Vn = 220;
Nn = 1500;
Wn = Nn*2*pi/60;
rendn = 0.9;
Cn = Pn*rendn/Wn;
Un = Vn*sqrt(3);

%parametres MAS
Rs = 10.5;
Ld = 0.245;
Lq = Ld;
Phi_f = 0.711;
J=0.05;
fv = 0.0033;
p=2;

Kond = Un/2;


Tiq = Lq/Rs;
n = 4;
Kpq = n*Rs/Kond;
Kpq_simscape = n*Rs;
En = p*Phi_f*Wn;
Iqref = Cn/p/Phi_f*2/3;
Idref = 0;
Tid = Ld/Rs;
Kpd = n*Rs/Kond;
Kpd_simscape = n*Rs;
Tv = J/fv;
kc = 3/2*p*Phi_f;
kv = 5*fv/kc;
kv_autopilotage = 5*fv/J;

Tsim_ft = 1;
Tsim_all = 30;
delay_fem = 0.1;
delay_torque = 15;

T0 = Lq/Kpq/Kond;

%% Simscape

%Onduleur
r = 0.8 ;
m=102; % multiple de 3
fh=m*fn;
Vdc=550;%((Vn*2)/r); %Cherchez le gain supplemen
Vc=1;
T_simscape = 25;
% Simulation
Ts = 1e-5 ;

