%TC EVV
%MAS 23
%Louis Saad - Antoine Sfeir
%%
clear all
close all
clc
%%
tps_sim = 10;                   %temps de simulation
freq = 50;                      %frequence nominale
In = 336;                       %courant nominal
Un = 400;                       %tension L-L
Vn = 400/sqrt(3);               %tension L-N
P = 1;                          %nbr de paires de poles
Pn = 200e3;                     %puissance nom
wn = 2*pi*freq;                 %pulsation propre
Cn = 643;                       %couple nom
Cmax = 3*Cn;                    %couple max
Cd = 2.4*Cn;                    %couple de demarrage
Nb = 60*freq/P;                 %vitesse de base
Wb = 2*pi*freq;                 %vitesse ang de base
Nn = 2972;                      %vitesse nom
Wn = 2*pi*Nn/60;                %vitesse ang nom
phin = acos(0.9);               %Phi nom
cosphin = 0.9;                  %PF nominal
pm = 1300;                      %pertes mecaniques
gn = (Nb-Nn)/Nb;                %glissement nom
J = 1.92;                       %moment d'inertie
Cemn = Cn + pm/Wn;              %Couple electromagnetique nominal

Np2w=400^2/(Wn*2*Cmax);         %Np2w

syms r2
frp2 = (Cn+pm/Wn)*(r2^2)/(gn^2) - P*r2*(Un^2)/(Wn*gn) + (Np2w^2)*(Cn+pm/Wn);
R2 = solve(frp2);
Rp2 = R2(2);                    %car pour R2(1) gm<gn

Rp2 = double(Rp2);
Rs = Rp2;
Rr = Rs;

Yab = In/(Vn-Rp2*In)*exp(-1j*phin);

Y23 = 1/(Rp2/gn+1j*Np2w);
Ym = Yab-Y23;
Rpfe = 1/real(Ym);
L1wn = -1/imag(Ym);
Zn = Un/sqrt(3)/In;
rpfe = Rpfe/Zn*100;
l1w = L1wn/Zn*100;

N_2 = Np2w/wn;
L1 = L1wn/wn;
Lss = N_2/2+2/3*L1;
Lrr = N_2/2+2/3*L1;
Ms = -1/3*L1;
Mr = -1/3*L1;
Msri = 2/3*L1;

Ls = Lss-Ms;
Lr = Lrr-Mr;
Msr = 3/2*Msri;

f = pm/(wn^2);

sigma = 1-Msr^2/Ls/Lr;

kc = Cn/Wn;                     %Coeficient de proportionalité W-C
k = f;                       %Coeficient de visquosité

Concordia = sqrt(2/3)*[1 -0.5 -0.5;0 sqrt(3)/2 -sqrt(3)/2;1/sqrt(2) 1/sqrt(2) 1/sqrt(2)];
IConcordia = inv(Concordia);
Flux = [Ls 0 Msr 0;0 Ls 0 Msr;Msr 0 Lr 0;0 Msr 0 Lr];
IFlux = inv(Flux);

Frn = Un/sqrt(3)/(2*pi*50);     %Flux rotorique nominal apprx. (domaine triphasé abc)
Frn_max = Frn*sqrt(2);          %Flux rotorique max apprx. (domaine triphasé abc)
Frdn = Frn*sqrt(3/2);           %Flux rotorique nominal apprx. (domaine DQ0)
Frdn_max = Frdn*sqrt(2);        %Flux rotorique max apprx. (domaine DQ0)

Imr_refn = Frdn_max/Msr;        %Courant magnetisant rotorique de reference max

Tr = Lr/Rr;
Ts = Ls/Rs;

%% Flux
Hf = tf(1/Rs,[sigma*Ts*Tr (Ts+Tr) 1]);
poleF = pole(Hf);               %Poles de la fct de tranfert du flux

%Regulateur flux PI
Kf = 0.02*3/Tr;                 %Gain du regulateur
Kf1 = 0.3*3/Tr;                 %Gain pour une simplification d'un pole de la fct de transfert
to_f = 1/(-poleF(2)); 
Cp = Kf * tf([to_f 1], [to_f 0]);

HfBF = feedback(Hf*Cp, 1);
TfBF = 0.755/3;                  
%% Couple
Hc = P*Msr^2/Lr*Imr_refn/Rs * tf(1, [sigma*Ls/Rs 1]) * tf(1, [TfBF 1]);
poleC = pole(Hc);
%since the couple will be placed after stabilisation of the flux we can
%consider TfBF has already been accomplished (not taken into consideration)
Hc1 = P*Msr^2/Lr*Imr_refn/Rs * tf(1, [sigma*Ls/Rs 1]);
poleC1 = pole(Hc1);

%Regulateur Couple PI
Kc1 = 0.28;                      %Gain pour une simplification d'un pole de la fct de transfert                   
to1_c = 1/(-poleC1);
to_c = 0.0055;
Kc = 1.6*3*to_c/sigma/Ts/(P*Msr^2/Lr*Imr_refn/Rs);      %Gain du regulateur
Cc1 = Kc1 * tf([to1_c 1], [to1_c 0]);
Cc = Kc * tf([to_c 1], [to_c 0]);

HcBF = feedback(Hc*Cc, 1);
TcBF = 0.0454/3;                       
%% Vitesse
Hv = tf(1, [J k]) * tf(1, [TcBF 1]);
poleV = pole(Hv);

%Regulateur Vitesse PI
%to_v = 1/-poleV(2);
to_v = J/k;
Kv = 3;
Cv = Kv * tf([to_v 1], [to_v 0]);

HvBF = feedback(Hv*Cv,1);

%% Mise a l'echelle
k0 = Vn*sqrt(2)/5;

%% Resistance variable constantes
alpha=4e-3;
T0=25;
echauffement=200;
tau=2;

%% Switches
deciderC = 1;
deciderC2 = 1;
C_in = Cn;
N_in = Nn;
decider_R = 1;


run('app1.mlapp')