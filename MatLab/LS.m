Nt = 8;
Nr = 64;
SNR = -10:5:20;
exp = 100;
nmse_LS = SNR * 0;
nmse_MMSE = SNR * 0;

mse = @(x,y) norm(x(:)-y(:),2)^2 / numel(x);
NMSE = @(x,y) mse(x,y)/norm(x(:))^2;

for idx = 1:exp
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
        
        %% LS estimator
        H_LS_est = pinv(x' * x) * x' * y_n;
        
        %% MMSE estimator
        H_MMSE_est = pinv(x' * x + 1/snr) * x' * y_n;

        %% Compute NMSE
        snr_i = find(snr == SNR);

        nmse_LS(snr_i)  = nmse_LS(snr_i) + calNMSE(H, H_LS_est);

        nmse_MMSE(snr_i)  = nmse_MMSE(snr_i) + NMSE(H, H_MMSE_est);

%         E     = H - H_est;
%         sum_E = sum(sum(E .* conj(E)));
%         sum_H = sum(sum(H .* conj(H)));
%         
%         nmse(snr_i)  = nmse(snr_i) + sum_E / sum_H;
    end
end

semilogy(SNR, nmse_LS / exp);
hold on;
semilogy(SNR, nmse_MMSE / exp);
legend('LS', 'MMSE');