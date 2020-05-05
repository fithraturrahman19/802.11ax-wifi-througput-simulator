% Course: Advanced Wireless Network, SeoulTech
% Plotting Wi-Fi throughput based on analytical model
% Muhammad Fithratur Rahman

close all;
clear all;

font_size = 12;

%% le transmission parameter
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
axTc = H + P/r + ACKtimeout; %it follows the legacy one

%% defining time for each 
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
for n = Nax
    
    Nle = N - n ;
    
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

    B(n) = (Ptrle * Psle + Ptrax * Psax) * P / E;
    Ble(n) = (Ptrle * Psle ) * P / E;
    Bax(n) = (Ptrax * Psax) * P / E;
    Pc(n) = ple;
    Pcle(n) = ple;
    Pcax(n) = pap;
    
end

%% making a graph of throughput and collision probability vs number of station

figure;
hold on
h = plot(Nax, B');
set(h,'Color','blue');
set(h,'LineWidth',2);  
xlabel('Number of AX STAs','FontSize',font_size)
ylabel('Throughput (Mbps)','FontSize',font_size)
axis([0 Nax(end) 0 r]);
grid on;
set(gca,'FontSize',font_size);

h = plot(Nax, Ble');
set(h,'Color','cyan');
set(h,'LineWidth',2);  
xlabel('Number of AX STAs','FontSize',font_size)
ylabel('Throughput (Mbps)','FontSize',font_size)
axis([0 Nax(end) 0 r]);
grid on;
set(gca,'FontSize',font_size);

h = plot(Nax, Bax');
set(h,'Color','black');
set(h,'LineWidth',2);  
xlabel('Number of AX STAs','FontSize',font_size)
ylabel('Throughput (Mbps)','FontSize',font_size)
axis([0 Nax(end) 0 r]);
grid on;
set(gca,'FontSize',font_size);

legend('system', 'legacy', 'ax');

hold off
figure;
hold on

h = plot(Nax, Pc'); % //MODIFICATION LINE//
set(h,'Color','blue');
set(h,'LineWidth',2);
xlabel('Number of AX STAs','FontSize',font_size)
ylabel('Collision probability','FontSize',font_size)
%title('Plot of sin(\Theta)')
axis([0 Nax(end) 0 1]);
grid on;
set(gca,'FontSize',font_size);

h = plot(Nax, Pcle', 'x'); % //MODIFICATION LINE//
set(h,'Color','blue');
set(h,'LineWidth',2);
xlabel('Number of AX STAs','FontSize',font_size)
ylabel('Collision probability','FontSize',font_size)
%title('Plot of sin(\Theta)')
axis([0 Nax(end) 0 1]);
grid on;
set(gca,'FontSize',font_size);

h = plot(Nax, Pcax'); % //MODIFICATION LINE//
set(h,'Color','black');
set(h,'LineWidth',2);
xlabel('Number of AX STAs','FontSize',font_size)
ylabel('Collision probability','FontSize',font_size)
%title('Plot of sin(\Theta)')
axis([0 Nax(end) 0 1]);
grid on;
set(gca,'FontSize',font_size);

legend('system', 'legacy', 'ax');

hold off
