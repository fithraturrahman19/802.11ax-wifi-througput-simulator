% Course: Advanced Wireless Network, SeoulTech
% Function to solve 4 nonlinear equations
% Muhammad Fithratur Rahman

function F = myfun(p, Nle, Nax, Wle, Wax, mle, max)

% tle = p(1)
% ple = p(2)
% tap = p(3)
% pap = p(4)  

F(1) = (2 * (1 - 2*p(2)) / ((1 - 2*p(2))*(Wle+1) + p(2) * Wle * (1 - (2*p(2))^mle))) - p(1);       %equation for tle
F(2) = 1 - ((1 - p(1))^(Nle-1) * (1 - p(3))) - p(2);       %equation for ple

F(3) = (2 * (1 - 2*p(4)) / ((1 - 2*p(4))*(Wax+1) + p(4) * Wax * (1 - (2*p(4))^max))) - p(3);       %equation for tap
F(4) = 1 - ((1 - p(1))^(Nle)) - p(4);    %equation for pap

end