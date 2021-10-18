%% Model file for simulation HNAD pseudomonas stutzeri

% Inputs:
% t = time
% y = concentration of species 
% t_Vc_mu = Matrix with simulated time, volume and mu
% Vm = volume medium
% p = parameter guesses for parameters 1-32

%% Description of the species
    % Intracellular species
        % y(1)= [NH3] 
        % y(2)= [NH2OH] 
        % y(3)= [NO]
        % y(4)= [NO3-]
        % y(5)= [NO2-]
        % y(6)= [N2O]
        % y(7)= [N2]

    % extracellular species
        % y(8)= [NH3]ex
        % y(9)= [NO3-]ex
        % y(10)= [NO2-]ex
        % y(11)= [NO]ex
        % y(12)= [N2O]ex
        % y(13) = [N2]ex

    % Population volume
        % Vc = Vc 

%% Parameters 
    %Max reaction rates
    % units: Vmax = mmol.min-1
        % Vmax1 = Vmax for R1 
        % Vmax2 = Vmax for R2 
        % Vmax3 = Vmax for R3
        % Vmax4a = Vmax for R4 forward
        % Vmax4b = Vmax for R4 backward
        % Vmax5a = Vmax for R5 forward
        % Vmax5b = Vmax for R5 backward
        % Vmax6 = Vmax for R6
        % Vmax7 = Vmax for R7 
        
     
    % sensitivity coefficients
    % units: Km = mmol
    
        % Km1 = Km for substrate NH3 for enzyme AMO
        % Km2 = Km for substrate NH2OH for enzyme HAO 
        % Km4a = Km for substrate NO2- for enzyme Nir
        % Km4b = Km for substrate NO for enzyme Nir
        % Km5a = Km for substrate NO3- for enzyme Nap
        % Km5b = Km for substrate NO2- for enzyme NxrAB
        % Km6 = Km for substrate NO for enzyme NOR
        % Km7 = Km for subsrate N2O for enzyme N2OR

    % Exchange reaction rates mmol.min-1
    
        % Tmax1a = uptake rate [NH3]ex
        % Tmax1b = excretion rate [NH3]
        % Tmax2a = uptake rate [NO3-]ex
        % Tmax2b = excretion rate [NO3-]
        % Tmax3a = uptake rate [NO2-]ex
        % Tmax3b = uptake rate [NO2-]
        
    % Sensitivites of transporters unit: mmol
        % KT1a = affinity of transporter for [NH3]ex
        % KT1b = affinity of transporter for [NH3}
        % KT2a = affinity of transporter for [NO3-]ex
        % KT2b = affinity of transporter for [NO3-]
        % KT3a = affinity of tranporter for [NO2-]ex
        % KT3b = affinity of transporter for [NO2-]
        
    % Gas diffusion constants unit: min-1    
        % kd1 = Diffusion constant NO
        % kd2 = Diffusion constant N2O
        % kd3 = diffusion constant N2

    %% Volume parameters (predetermined)
% mumax1 = maximum growth rate on [NH3]ex
% mumax2 = maximum growth rate on [NO3-]ex
% KNH3 = sensitivity constant for [NH3]ex
% KNO3- = sensitivity constant for [NO3-]ex


function [dydt] = HNAD_sim_Vol_optimize(t,y,Vm,t_Vc_mu,p)
% Input parameters

    %  Intracellular reactions
Vmax1 = p(1);
Vmax2 = p(2);
Vmax3 = p(3);
Vmax4a = p(4);
Vmax4b = p(5);
Vmax5a = p(6);
Vmax5b = p(7);
Vmax6 = p(8);
Vmax7 = p(9);

Km1 = p(10);
Km2 = p(11);
Km4a = p(12);
Km4b = p(13);
Km5a = p(14);
Km5b = p(15);
Km6 = p(16);
Km7 = p(17);

    % Transport reactions
 % Transport rate
 
Tmax1a = p(18);
Tmax1b = p(19);
KT1a = p(20);
KT1b =p(21);

Tmax2a = p(22);
Tmax2b =p(23);
KT2a = p(24);
KT2b = p(25);

Tmax3a = p(26);
Tmax3b = p(27);
KT3a = p(28);
KT3b = p(29);

 % Gas release factors
kd1 = p(30);
kd2= p(31);
kd3 = p(32);
 
    % Model equations
% Matrix for y
dydt = zeros(size(y));

%  Volume and mu
Vc = interp1(t_Vc_mu(:,1),t_Vc_mu(:,2),t)';
mu = interp1(t_Vc_mu(:,1),t_Vc_mu(:,3),t)';

%Intracellular species
%dNH3/dt 
dydt(1) = ((Tmax1a*y(8)*Vm/KT1a-Tmax1b*y(1)*Vc/KT1b)/(1+y(8)*Vm/KT1a+y(1)*Vc/KT1b)-(Vmax1*y(1)*Vc/(Km1+y(1)*Vc)))/Vc-mu*y(1);
%dNH2OH/dt
dydt(2) = (Vmax1*y(1)*Vc/(Km1+y(1)*Vc)-Vmax2*y(2)*Vc/(Km2+y(2)*Vc)-2*Vmax3*(y(2)^2)*(Vc^2)/((Km2^2)+(y(2)^2)*(Vc^2)))/Vc-mu*y(2);
%dNO/dt
dydt(3) = (Vmax2*y(2)*Vc/(Km2+y(2)*Vc)+(Vmax4a*y(5)*Vc/Km4a-Vmax4b*y(3)*Vc/Km4b)/(1+y(5)*Vc/Km4a+y(3)*Vc/Km4b)-2*Vmax6*(y(3)^2)*(Vc^2)/((Km6^2)+(y(3)^2)*(Vc^2))-kd1*(y(3)-y(11)))/Vc-mu*y(3);
%dNO3-/dt
dydt(4)= ((Tmax2a*y(9)*Vm/KT2a-Tmax2b*y(4)*Vc/KT2b)/(1+y(9)*Vm/KT2a+y(4)*Vc/KT2b)-(Vmax5a*y(4)*Vc/Km5a-Vmax5b*y(5)*Vc/Km5b)/(1+y(4)*Vc/Km5a+y(5)*Vc/Km5b))/Vc-mu*y(4);
%dNO2-/dt
dydt(5)= ((Tmax3a*y(10)*Vm/KT3a-Tmax3b*y(5)*Vc/KT3b)/(1+y(10)*Vm/KT3a+y(5)*Vc/KT3b)-(Vmax4a*y(5)*Vc/Km4a-Vmax4b*y(3)*Vc/Km4b)/(1+y(5)*Vc/Km4a+y(3)*Vc/Km4b)+(Vmax5a*y(4)*Vc/Km5a-Vmax5b*y(5)*Vc/Km5b)/(1+y(4)*Vc/Km5a+y(5)*Vc/Km5b))/Vc-mu*y(5);
%N2O/dt
dydt(6)= (Vmax3*(y(2)^2)*(Vc^2)/((Km2^2)+(y(2)^2)*(Vc^2))+Vmax6*(y(3)^2)*(Vc^2)/((Km6^2)+(y(3)^2)*(Vc^2))-Vmax7*y(6)*Vc/(Km7+y(6)*Vc)-kd2*(y(6)-y(12)))/Vc-mu*y(6);
%N2/dt
dydt(7)= (Vmax7*y(6)*Vc/(Km7+y(6)*Vc)-kd3*(y(7)-y(13)))/Vc-mu*y(7);

%extracellular species
%NH3ex/dt
dydt(8)= -((Tmax1a*y(8)*Vm/KT1a-Tmax1b*y(1)*Vc/KT1b)/(1+y(8)*Vm/KT1a+y(1)*Vc/KT1b))/Vm;
%NO3-ex/dt
dydt(9)= -((Tmax2a*y(9)*Vm/KT2a-Tmax2b*y(4)*Vc/KT2b)/(1+y(9)*Vm/KT2a+y(4)*Vc/KT2b))/Vm;
%NO2-ex/dt
dydt(10)= -((Tmax3a*y(10)*Vm/KT3a-Tmax3b*y(5)*Vc/KT3b)/(1+y(10)*Vm/KT3a+y(5)*Vc/KT3b))/Vm;
%NOex/dt
dydt(11)= kd1*(y(3)-y(11))/Vm;
%N2Oex/dt
dydt(12)= kd2*(y(6)-y(12))/Vm;
%N2ex/dt
dydt(13)= kd3*(y(7)-y(13))/Vm;
end