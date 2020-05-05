% Course: Advanced Wireless Network, SeoulTech
% Plotting Wi-Fi throughput based on simulation
% Muhammad Fithratur Rahman

close all;
clear all;

global N r P CWmin m simslot;

font_size = 12;

%N = 10;         % Number of contending stations
r = 18;         % TX rate in Mbps
P = 1500 * 8;   % Payload size (in bits)

CWmin = 16;     % Minimum CW size
m = 6;          % Maximum backoff stage

simslot = 100000;  % Number of slots to be considered for each simulation run

    Nax = [1:50];
    i = 1;
    for N=Nax
        [B(i) axB(i) leB(i) Pc(i) axPc(i) lePc(i)] = term_project_wifi_sim();
        i = i + 1;
    end
%% 

figure;
h = plot(Nax, B','o');
set(h,'LineWidth',3);   
xlabel('Number of ax STAs','FontSize',font_size)
ylabel('Throughput (Mbps)','FontSize',font_size)
axis([0 Nax(end) 0 r]);
grid on;
set(gca,'FontSize',font_size);

figure;
h = plot(Nax, axB','o');
set(h,'LineWidth',3);   
xlabel('Number of ax STAs','FontSize',font_size)
ylabel('Throughput (Mbps)','FontSize',font_size)
axis([0 Nax(end) 0 r]);
grid on;
set(gca,'FontSize',font_size);

figure;
h = plot(Nax, leB','o');
set(h,'LineWidth',3);   
xlabel('Number of ax STAs','FontSize',font_size)
ylabel('Throughput (Mbps)','FontSize',font_size)
axis([0 Nax(end) 0 r]);
grid on;
set(gca,'FontSize',font_size);

figure;
h = plot(Nax, Pc','o');
set(h,'LineWidth',3);   
xlabel('Number of ax STAs','FontSize',font_size)
%xlabel('Number of LTE LAA eNBs + UEs','FontSize',font_size)
ylabel('Collision probability','FontSize',font_size)
%ylabel('Collision overhead (%)','FontSize',font_size)
%title('Plot of sin(\Theta)')
axis([0 Nax(end) 0 1]);
grid on;
set(gca,'FontSize',font_size);

figure;
h = plot(Nax, axPc','o');
set(h,'LineWidth',3);   
xlabel('Number of ax STAs','FontSize',font_size)
%xlabel('Number of LTE LAA eNBs + UEs','FontSize',font_size)
ylabel('Collision probability','FontSize',font_size)
%ylabel('Collision overhead (%)','FontSize',font_size)
%title('Plot of sin(\Theta)')
axis([0 Nax(end) 0 1]);
grid on;
set(gca,'FontSize',font_size);

figure;
h = plot(Nax, lePc','o');
set(h,'LineWidth',3);   
xlabel('Number of ax STAs','FontSize',font_size)
%xlabel('Number of LTE LAA eNBs + UEs','FontSize',font_size)
ylabel('Collision probability','FontSize',font_size)
%ylabel('Collision overhead (%)','FontSize',font_size)
%title('Plot of sin(\Theta)')
axis([0 Nax(end) 0 1]);
grid on;
set(gca,'FontSize',font_size);