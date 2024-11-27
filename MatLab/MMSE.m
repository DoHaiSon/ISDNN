Nt = 8;
Nr = 64;
Nr_UCA  = 16;        % UCA
Nr_ULA  = 4;         % UCyA
SNR = 0:2:20;
num_exp = 1000;
nmse_LS = SNR * 0;
nmse_MMSE = SNR * 0;

mse = @(x,y) norm(x(:)-y(:),2)^2 / numel(x);
NMSE = @(x,y) mse(x,y)/norm(x(:))^2;

for idx = 1:num_exp
    % Generate pilot: QAM-16 symbols, 1 x Nt
        data = randi([0 15], 1, Nt);
        x    = qammod(data, 16) / 3;
        
        % Generate channel: rand(H), Nt x Nr
        H    = (rand(Nt, Nr) + 1i * rand(Nt, Nr)) / sqrt(2);

        % Receive signal w/o noise
        y    = x * H;

    for snr = SNR
        % add noise
        y_n  = awgn(y, snr);

        snr_linear = 10^(-snr / 10);

        
        %% LS estimator
        H_LS_est = pinv(x' * x) * x' * y_n;
        
        %% MMSE estimator
        H_MMSE_est = pinv(x' * x + snr_linear * eye(Nt)) * x' * y_n;

        %% Compute NMSE
        snr_i = find(snr == SNR);

        nmse_LS(snr_i)  = nmse_LS(snr_i) + calNMSE(H, H_LS_est);

        nmse_MMSE(snr_i)  = nmse_MMSE(snr_i) + calNMSE(H, H_MMSE_est);

    end
end

plot(SNR, log10(nmse_LS / num_exp));
hold on;
plot(SNR, log10(nmse_MMSE / num_exp));
legend('LS', 'MMSE');