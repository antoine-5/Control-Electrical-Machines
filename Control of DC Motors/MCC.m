clear all
close all
clc

%%
Un = 600;                           %V
In = 69;                            %A
R = 0.64;                           %ohm
PJn = R*In*In;                      % Watt
Pn = 41.4e3;                        % Watt
eta = 0.89;                         %pu
Nn = 3390;                          % tr/min ou RPM
Omega_n = Nn*2*pi/60;               % rad/s
L = 6.3e-3;                         % H
Cn = 104;                           % N.m
J = 0.12;                           % Kg.m^2

gamma = PJn/Pn;

alfa = 3/5*(1-eta-gamma);
beta = 2/3*alfa;
PMn = alfa*Pn;
f_1 = PMn/Omega_n/Omega_n;
phi_0 = (Un-R*In)/Omega_n;
f = (phi_0*In-Cn)/Omega_n;
kfer = f-f_1;
Cemn = (Pn-PJn)/Omega_n;

%% Correction
Eps_n = 4.69;
w_0 = 2*pi*30;
xi = sqrt(2)/2;

kc = Cn/Omega_n;
k = f+kc;
to_2 = J/k;
cte = L/R;
k1 = 1/cte/(Un/In);
k2 = 5*k*to_2/0.3943/phi_0/In*Omega_n;
Kgt = 90/(2*pi/60*1500);
Kech = Eps_n/Omega_n/Kgt;
rad_V = Eps_n/Omega_n;                  %157.08/k=4.69


alfa_echauffement = 4e-3;
delta_teta = 75;
R40 = R/(1+alfa_echauffement*delta_teta);
tau = 1;
shunt = 1/240;

%% Simscape

Pexc = 0.7e3;
Uf = 310;
Ifn = Pexc/Uf;
Rf = Uf/Ifn;
Lf = 0.75*Rf;
Laf = phi_0/Ifn;
to_i = L/R;
Ki = 15;
Kw = 8;
to_w = J/f;


%% Switches
Cycle = 0;                              % =0 donc pas de cycle de vitesse
T_sim = 5;
Nref = Nn;
Cref = Cn;
Rvar_ou_pas = 0;                        % =0 => R non variable
Cr_ou_pas = 0;                          %=0 => couple proportionnel a la vitesse ou a vide
Imperfection_capteur_ou_pas = 0;        % =0 => pas de simulation d'imperfection de capteur

normal = 1;
var1 = 0;
cycle_vitesse = 0;
prompt = 'Bonjour\n Pour travailler normalement avec couple proportionnelle kc=Cn/Omega_n \nsans résistance variable et sans imperfection de capteur pressez (1) sinon pressez (0)\n';
normal = input(prompt);
if normal == 0
   prompt = "Voulez vous appliquer un cycle de vitesse(Nn 0-10s//-Nn 10-20//Nn/2 20-25//Nn/100 25-35//0) pressez(1) sinon pressez(0)\n";
   cycle_vitesse = input(prompt);
   if cycle_vitesse==1
        kc = 0;
        T_sim = 50;
        Cr_ou_pas = 1;
   else
       prompt = 'Pour travailler avec un couple proportionnel à la vitesse ou à vide pressez (0)\n sinon un couple constant et donc pressez (1)\n';
       Cr_ou_pas = input(prompt);
       if Cr_ou_pas==0
           prompt = "Pour travailler avec un couple proportionnelle pressez (1) sinon à vide pressez (0)\n";
           var1 = input(prompt);
           if var1==0
               kc = 0;
               T_sim = 5;
           else
               kc = Cn/Omega_n;
               T_sim = 5;
           end
       else
           prompt = 'On travaillera avec un couple constant. Entrez la valeur du couple sachant que Cn=104\n';
           Cref = input(prompt);
           kc = 0;
           T_sim = 20;
       end
   prompt = "Pour simuler une résistance de l'induit variable rotorique pressez (1) sinon pressez (0)\n";
   Rvar_ou_pas = input(prompt);
   prompt = "Pour simuler l'imperfection des capteurs pressez (1) sinon pressez (0)\n";
   Imperfection_capteur_ou_pas = input(prompt);
   end
end

k = f+kc;
to_2 = J/k;
cte = L/R;
k1 = 1/cte/(Un/In);
k2 = 5*k*to_2/0.3943/phi_0/In*Omega_n;

%% plotting

sim('MCC_5_Sim_Antoine_Louis')

figure('NumberTitle', 'off', 'Name', 'Vitesse en fonction du temps');
plot(t,Omega*60/2/pi)
hold on
grid on
if cycle_vitesse == 1
    plot(t,CV_ref);
else
    plot(t,Omega_ref*60/2/pi)
end
xlabel('temps (s)')
ylabel('N (tr/min)')
title('Vitesse en fonction du temps')
%axis([0 3.5 0 4000])
legend('N','Nref')
figure('NumberTitle', 'off', 'Name', 'Intensité en fonction du temps');
plot(t,I)
hold on
grid on
if cycle_vitesse == 0
    plot(t,Inn)
    legend('I','Iref')
end
xlabel('temps (s)')
ylabel('I (A)')
title('Intensité en fonction du temps')
if normal ==1 
    axis([0 0.4 0 120])
end


