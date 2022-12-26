close all

% sim('cmd_vectorielle_05')
figure()
plot(t,Idq),grid
xlabel('temps | s')
ylabel('Idq | A')
legend('Id','Iq')

figure()
plot(t,Vdq),grid
xlabel('temps | s')
ylabel(' Module de V_{dq} | V')
legend('| Vdq |','Tension maximale supporté par la MS')

figure()
plot(t,Cem),grid
xlabel('temps | s')
ylabel('Cem ')
legend('Cem')

figure()
plot(t,Vitesse),grid
hold on
plot(t,Vitesse_ref)
xlabel('temps | s')
ylabel('Vitesse | rad/s')
legend('Vitesse','Vitesse_{ref}')