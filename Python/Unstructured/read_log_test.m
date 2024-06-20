raw = load('./model_20k_5l/log_test.txt');

step = 2;
SNR = 0:step:20;
num_snr = length(SNR);

NMSE = SNR * 0;

for i = 1:num_snr
    NMSE(i) = mean(raw(2*i: 2*num_snr: end));
end

semilogy(SNR, NMSE);