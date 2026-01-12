clc;
clear;
close all;

N = 1e5;
EbN0_dB = 0:1:10;
BER = zeros(1,length(EbN0_dB));

data = randi([0 1], 1, N);
data_I = data(1:2:end);
data_Q = data(2:2:end);

% QPSK Modulation
I = 2*data_I - 1;
Q = 2*data_Q - 1;
qpsk_signal = (I + 1j*Q)/sqrt(2);

for i = 1:length(EbN0_dB)
    EbN0 = 10^(EbN0_dB(i)/10);
    noise = sqrt(1/(2*EbN0))*(randn(size(qpsk_signal)) + 1j*randn(size(qpsk_signal)));
    
    received = qpsk_signal + noise;
    
    detected_I = real(received) > 0;
    detected_Q = imag(received) > 0;
    
    detected = zeros(1,N);
    detected(1:2:end) = detected_I;
    detected(2:2:end) = detected_Q;
    
    BER(i) = sum(data ~= detected)/N;
end

figure;
semilogy(EbN0_dB, BER,'o-');
grid on;
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate');
title('QPSK over AWGN Channel');
