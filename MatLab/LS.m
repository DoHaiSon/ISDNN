Nt = 8;
Nr = 64;
Nr_UCA  = 16;        % UCA
Nr_ULA  = 4;         % UCyA
SNR = 0:2:20;
num_exp = 1000;
nmse_LS = SNR * 0;
% nmse_MMSE = SNR * 0;
% rng(0,'twister');
% min_oa = -pi / 2;
% max_oa = pi / 2;
% dH = 1;
% 
% %% Generate position of elements in arrays
% d_ULA_nor   = 0.5;
% d_UCA_nor   = 0.5;
% R_nor       = 0.5 * d_UCA_nor/sin(pi/Nr_UCA);
% 
% UCyA_elements_nor   = zeros(3, Nr_ULA, Nr_UCA);
% 
% for Nr_ULA_index=1:Nr_ULA
%     for Nr_UCA_index=1:Nr_UCA
%         UCyA_elements_nor(1, Nr_ULA_index, Nr_UCA_index) = R_nor * sin((Nr_UCA_index-1)*(2*pi/Nr_UCA)) ;         % x
%         UCyA_elements_nor(2, Nr_ULA_index, Nr_UCA_index) = R_nor * cos((Nr_UCA_index-1)*(2*pi/Nr_UCA)) ;         % y
%         UCyA_elements_nor(3, Nr_ULA_index, Nr_UCA_index) = (Nr_ULA_index-1) * d_ULA_nor;                         % z
%     end
% end

mse = @(x,y) norm(x(:)-y(:),2)^2 / numel(x);
NMSE = @(x,y) mse(x,y)/norm(x(:))^2;

for idx = 1:num_exp
    % Generate pilot: QAM-16 symbols, 1 x Nt
        data = randi([0 15], 1, Nt);
        x    = qammod(data, 16) / 3;
        
        % Generate channel: rand(H), Nt x Nr
        H    = (rand(Nt, Nr) + 1i * rand(Nt, Nr)) / sqrt(2);
        
%         Aoa = [];
%         Zoa = [];
%         for nt = (1:Nt)
%             zoa = (max_oa-min_oa).*rand(dH,1) + min_oa;
%             aoa = (max_oa-min_oa).*rand(dH,1) + min_oa;
% 
%             Zoa = [Zoa; zoa];
%             Aoa = [Aoa; aoa];
%         end
%         
%         tmp = 0;
%         H_oG = [];
%         for nt = (1:Nt)
%             r = 0;
%             for Nr_ULA_index = (1:Nr_ULA)
%                 for Nr_UCA_index = (1:Nr_UCA)
%                     r = r + 1;
%                     h = 0;
%                     for dh = (1:dH)
%                         r_x = sin(Zoa(nt, dh)) * cos(Aoa(nt, dh));
%                         r_y = sin(Zoa(nt, dh)) * sin(Aoa(nt, dh));
%                         r_z = cos(Zoa(nt, dh));
% 
%                         tmp = exp(-1i*2*pi *(UCyA_elements_nor(1, Nr_ULA_index, Nr_UCA_index)*r_x ...
%                                            + UCyA_elements_nor(2, Nr_ULA_index, Nr_UCA_index)*r_y ... 
%                                            + UCyA_elements_nor(3, Nr_ULA_index, Nr_UCA_index)*r_z));
%                     end
% 
%                     H_oG(nt, r) = H(nt, r) / tmp;
%                 end
%             end
%         end
% 
%         % Receive signal w/o noise
%         H    = H_oG;
        y    = x * H;

    for snr = SNR
        % add noise
        y_n  = awgn(y, snr);
        
        %% LS estimator
        H_LS_est = pinv(x' * x) * x' * y_n;
        
        %% MMSE estimator
%         H_MMSE_est = pinv(x' * x + 1/snr) * x' * y_n;

        %% Compute NMSE
        snr_i = find(snr == SNR);

        nmse_LS(snr_i)  = nmse_LS(snr_i) + calNMSE(H, H_LS_est);

%         nmse_MMSE(snr_i)  = nmse_MMSE(snr_i) + NMSE(H, H_MMSE_est);

%         E     = H - H_est;
%         sum_E = sum(sum(E .* conj(E)));
%         sum_H = sum(sum(H .* conj(H)));
%         
%         nmse(snr_i)  = nmse(snr_i) + sum_E / sum_H;
    end
end

plot(SNR, log10(nmse_LS / num_exp));
% hold on;
% semilogy(SNR, nmse_MMSE / num_exp);
% legend('LS', 'MMSE');