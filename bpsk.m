clc;
clear;
close all;

% Parameters
N = 1e5;                 % Number of bits
EbN0_dB = 0:1:10;        % SNR range
BER_sim = zeros(1,length(EbN0_dB));

% Generate random data
data = randi([0 1], 1, N);

% BPSK Modulation
bpsk_mod = 2*data - 1;   % 0 -> -1, 1 -> +1

for i = 1:length(EbN0_dB)
    EbN0 = 10^(EbN0_dB(i)/10);
    noise_var = 1/(2*EbN0);
    
    noise = sqrt(noise_var) * randn(1, N);
    received = bpsk_mod + noise;
    
    % Demodulation
    detected = received > 0;
    
    % BER calculation
    BER_sim(i) = sum(data ~= detected)/N;
end

% Theoretical BER
BER_theory = 0.5 * erfc(sqrt(10.^(EbN0_dB/10)));

% Plot
figure;
semilogy(EbN0_dB, BER_sim,'o-',EbN0_dB,BER_theory,'--');
grid on;
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate');
legend('Simulated BER','Theoretical BER');
title('BPSK over AWGN Channel');
