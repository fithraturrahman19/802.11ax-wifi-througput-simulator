% Course: Advanced Wireless Network, SeoulTech
% Plotting Wi-Fi throughput based on simulation and analysis
% Muhammad Fithratur Rahman

close all;
clear all;

%% SIMULATION
global N r P CWmin m simslot;

font_size = 12;

%N = 10;         % Number of contending stations
r = 18;         % TX rate in Mbps
P = 1500 * 8;   % Payload size (in bits)

CWmin = 16;     % Minimum CW size
m = 6;          % Maximum backoff stage

simslot = 1000000;  % Number of slots to be considered for each simulation run

Nax = [1:50];
i = 1;
for N=Nax
    [B(i) axB(i) leB(i) Pc(i) axPc(i) lePc(i)] = term_project_wifi_sim();
    i = i + 1;
end

%% ANALYSIS
r = 18;        % TX rate in Mbps
P = 1500 * 8;   % Payload size (in bits)

W = 16;
m = 6;

% 11ac params (in us)
PSLOT = 9;
PHY = 44;   

H = PHY + 224/r;
SIFS = 16;
DIFS = 34;
ACK = PHY + 14*8/r;
ACKtimeout = SIFS + ACK + DIFS;

Ti = PSLOT;
Ts = H + P/r + SIFS + ACK + DIFS;
Tc = H + P/r + ACKtimeout;

%% ax transmission params
axr = 18;        % TX rate in Mbps
axp = 1500 * 8;   % Payload size (in bits)

axW = 16;
axm = 6;


axTF = 100;

% 11ac params (in us)
axPSLOT = 9;
axPHY = 44;   
axH = PHY + 224/r;
axSIFS = 16;
axDIFS = 34;
axACK = PHY + 14*8/r;
axACKtimeout = SIFS + ACK + DIFS;

axTi = PSLOT;
axTs = H + P/r + SIFS + ACK + DIFS + SIFS + axTF;
axTc = H + P/r + ACKtimeout;

axpe = 0.0; % channel error rate defined //MODIFICATION LINE//

Tsle = Ts;
Tcle = Tc;
Tsax = axTs;
Tcax = axTc;

Wle = W;
mle = m;
Wax = axW;
max = axm;

%% analysis for every n (number of station), to get the throughput B(n) and collision (or failing) probability Pp(n)
N = 50; %number of total stations //MODIFICATION LINE//
Nax = 1:1:50; %nsta -> nax
for n=Nax
    Nle = N - n;
    
    p = lsqnonlin(@(p) term_project_wifi_solve(p, Nle, Nax, Wle, Wax, mle, max), [0.1 0.1 0.1 0.1]);
    tle = p(1);
    ple = p(2);
    tap = p(3);
    pap = p(4);
    
    Ptrle = 1 - (1 - tle) ^ (Nle);
    if Ptrle == 0
        Psle = Nle * tle * ((1 - tle) ^ (Nle - 1)) * (1 - tap);
    else
        Psle = Nle * tle * ((1 - tle) ^ (Nle - 1)) * (1 - tap) / Ptrle;
    end
    Ptrax = 1 - (1 - tap);
    Psax = tap * (1 - tle) ^ (Nle) / Ptrax;
    
    E = Ti * (1 - Ptrle)*(1 - Ptrax) + Tsle * (Ptrle * Psle) + Tsax * (Ptrax * Psax) + Tcle * (Ptrle * (1 - Psle)) + Tcax * (Ptrax * (1 - Psax)) - Tcax * (Ptrax * Ptrle);

    B2(n) = (Ptrle * Psle + Ptrax * Psax) * P / E;
    Pc2(n) = ple;
    
end


figure;
h = plot(Nax, B','o');
hold on

set(h,'LineWidth',2);   
xlabel('Number of ax STAs','FontSize',font_size)
ylabel('Throughput (Mbps)','FontSize',font_size)
axis([0 Nax(end) 0 r]);
grid on;
set(gca,'FontSize',font_size);

%figure;
h = plot(Nax, B2');
set(h,'Color','blue');
set(h,'LineWidth',2);  

xlabel('Number of AX STAs','FontSize',font_size)
ylabel('Throughput (Mbps)','FontSize',font_size)
axis([0 Nax(end) 0 r]);
grid on;
legend('simulation', 'analysis');

set(gca,'FontSize',font_size);

hold off

figure;

h = plot(Nax, Pc','o');
hold on

set(h,'LineWidth',2);   
xlabel('Number of ax STAs','FontSize',font_size)
%xlabel('Number of LTE LAA eNBs + UEs','FontSize',font_size)
ylabel('Collision probability','FontSize',font_size)
%ylabel('Collision overhead (%)','FontSize',font_size)
%title('Plot of sin(\Theta)')
axis([0 Nax(end) 0 1]);
grid on;
set(gca,'FontSize',font_size);

%figure;

h = plot(Nax, Pc2'); % //MODIFICATION LINE//
set(h,'Color','blue');
set(h,'LineWidth',2);
xlabel('Number of AX STAs','FontSize',font_size)
ylabel('Collision probability','FontSize',font_size)
%title('Plot of sin(\Theta)')
axis([0 Nax(end) 0 1]);
grid on;

legend('simulation', 'analysis');
set(gca,'FontSize',font_size);

hold off