sim('MAS23_sim_echelle.slx')

figure()
plot(Tout,ID),grid
hold on
plot(Tout,IQ)
xlabel('temps | s')
ylabel('I | A')
legend('I_D','I_Q')
title("Courant");

figure()
grid on
plot(Tout,CemS),grid
hold on
plot(Tout,CemSR)
xlabel('temps | s')
ylabel('C | N.m')
legend('Cem','Cem_{ref}')
title("Couple électromagnetique");

figure()
plot(Tout,N),grid
hold on
plot(Tout,NR)
xlabel('temps | s')
ylabel('N | tr/min')
legend('N','N_{ref}')
title("Vitesse de Rotation de l'arbre");

figure()
plot(Tout,Phi_RD),grid
hold on
plot(Tout,Phi_RQ)
xlabel('temps | s')
ylabel('Les flux')
legend('\phi_{RD}','\phi_{RQ}')
title("Flux de la MAS");