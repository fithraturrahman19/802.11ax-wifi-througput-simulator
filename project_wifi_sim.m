% Course: Advanced Wireless Network, SeoulTech
% Plotting Wi-Fi throughput based on simulation
% Muhammad Fithratur Rahman

%% defining function and parameter used
function [B axB leB Pc axPc lePc] = term_project_wifi_sim()

global N r P CWmin m simslot;

%% legacy parameter
% 11ac params (in us)
PSLOT = 9;
PHY = 44;   
H = PHY + 224/r;
SIFS = 16;
DIFS = 34;
ACK = PHY + 14*8/r;
ACKtimeout = SIFS + ACK + DIFS;

Ts = H + P/r + SIFS + ACK + DIFS;
Tc = H + P/r + ACKtimeout;

bo = round(CWmin * rand(50,1));      % Initialize stations' backoff counts
bstg = zeros(50,1);                  % Initialize stations' backoff stage to zero
Nattempt = 0;                       % Number of TX attempts
Ns = 0;                             % Number of TX successes
Nc = 0;                             % Number of TX failures due to collision
t = 0;                              % Simulation time (us)

leNattempt = 0;
leNc = 0;
leNs = 0;

%% ax parameter
axPSLOT = 9;
axPHY = 44;   
axH = PHY + 224/r;
axSIFS = 16;
axDIFS = 34;
axACK = PHY + 14*8/r;
axACKtimeout = SIFS + ACK + DIFS;
axTF = 100; %MODIFLINE

axTs = H + P/r + SIFS + ACK + DIFS + SIFS + axTF;
axTc = H + P/r + ACKtimeout;

axbo = round(CWmin * rand(1,1));      % Initialize stations' backoff counts
axbstg = zeros(1,1);                  % Initialize stations' backoff stage to zero
axNattempt = 0;                       % Number of TX attempts
axNs = 0;                             % Number of TX successes
axNc = 0;                             % Number of TX failures due to collision
axt = 0;                              % Simulation time (us)

%% wifi simulations for n stations for simslot time
Ncont = 50 - N;
% i: slot index
for i=1:1:simslot
    Ntx = 0;    % Number of transmitting stations in this slot
    axNtx = 0;  % Number of transmitting le stations in this slot
    leNtx = 0;  % Number of transmitting ax-group in this slot
    
    for n=1:Ncont
        if (bo(n) <= 0)         % Check each le station's backoff count
            Ntx = Ntx + 1;      % If the backoff count of a station is zero, it transmits now
            leNtx = leNtx + 1;
        end
    end
        if (axbo(1) <= 0)         % Check ax station's backoff count
            Ntx = Ntx + 1;          % if ax transmit, add Ntx
            axNtx = axNtx + 1;      % If the backoff count of a station is zero, it transmits now
            %leNtx = leNtx - 1;
        end
    Nattempt = Nattempt + Ntx;
    axNattempt = axNattempt + axNtx;
    leNattempt = leNattempt + leNtx;
    
    if (Ntx > 1)                % Multiple stations transmit in this slot
        t = t + Tc;             % Advance the simulation time by Tc
        for n=1:Ncont
            if (bo(n) <= 0)     % If this station transmitted in this slot
                Nc = Nc + 1;
                leNc = leNc + 1;
                bstg(n) = min(bstg(n) + 1, m);              % It needs to increase its backoff stage
                %bo(n) = round(CWmin * 2^bstg(n) * rand);    % and reset the backoff count based on the new stage
                bo(n) = mod(round(rand * 10000), CWmin * 2^bstg(n));                
            end
        end
            if (axbo(1) <= 0)     % If ax station transmitted in this slot
                t = t - Tc + axTc;
                Nc = Nc + 1;
                axNc = axNc + 1;
                %leNc = leNc - 1;
                axbstg(1) = min(axbstg(1) + 1, m);              % It needs to increase its backoff stage
                %bo(n) = round(CWmin * 2^bstg(n) * rand);    % and reset the backoff count based on the new stage
                axbo(1) = mod(round(rand * 10000), CWmin * 2^axbstg(1));                
            end
    elseif (Ntx == 1)           % Only one station transmits in this slot
        t = t + Ts;             % Advance the simulation time by Ts
        Ns = Ns + 1;
        for n=1:Ncont
            if (bo(n) <= 0)     % If this station transmitted in this slot
                leNs = leNs + 1;
                bstg(n) = 0;                                % Reset its backoff stage
                %bo(n) = round(CWmin * rand);    % and reset the backoff count
                bo(n) = mod(round(rand * 10000), CWmin * 2^bstg(n));
            end
        end      
            if (axbo(1) <= 0)     % If this station transmitted in this slot
                t = t - Ts + axTs;
                axNs = axNs + 1;
                axbstg(1) = 0;                                % Reset its backoff stage
                %bo(n) = round(CWmin * rand);    % and reset the backoff count
                axbo(1) = mod(round(rand * 10000), CWmin * 2^axbstg(1));
            end
    else                        % No TX in this slot
        t = t + PSLOT;          % Advance the simulation time by a physical slot
        for n=1:Ncont
            bo(n) = bo(n) - 1;  % Decrease the backoff count of every station since the medium is idle during this slot
        end
            axbo(1) = axbo(1) - 1;
    end    
end

%% calculating the throughput and collision or failure probability

B = Ns * P / t; %t is total time after all process
axB = axNs * P / t;
leB = leNs * P / t;
Pc = Nc / Nattempt;
axPc = axNc / axNattempt;
lePc = leNc / leNattempt;

