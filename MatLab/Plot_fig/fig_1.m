snr = load("./SNR_sim.mat");
NMSE_sim = load("NMSE_sim.mat");

raw_unstr = load('C:\Users\SON\Desktop\ISDNN\Python\Unstructured\model_10k_4l\log_test.txt');
raw_str = load('C:\Users\SON\Desktop\ISDNN\Python\Structured\model_10k_4l\log_test.txt');

step = 2;
SNR = 0:step:20;
num_snr = length(SNR);

NMSE = SNR * 0;

for i = 1:num_snr
    NMSE_unstr(i) = mean(raw_unstr(2*i: 2*num_snr: end));
end

for i = 1:num_snr
    NMSE_str(i) = mean(raw_str(2*i: 2*num_snr: end));
end

plot(snr.SNR, log10(NMSE_sim.ans), '-*', 'LineWidth', 1.5, 'Color', "#0072BD", 'MarkerSize', 7);
hold on;
plot(SNR, log10(NMSE_unstr), '-g o', 'LineWidth', 1.5, 'Color', "#FF0000", 'MarkerFaceColor', "#FFFF00")
plot(SNR, log10(NMSE_str), '-g d', 'LineWidth', 1.5, 'Color', "#7E2F8E", 'MarkerFaceColor', "#FFFF00");

grid minor;
ylabel('NMSE', 'FontSize', 14, 'Interpreter','latex');
xlabel('SNR (dB)', 'FontSize', 14, 'Interpreter','latex');
legend('LS', 'ISDNN: 4 layers', 'S-ISDNN: 4 layers', ...
    'Interpreter', 'latex', 'FontSize', 14, 'Edgecolor', 'white');
hAx=gca;                              % get the axes handle
hAx.XTickLabel=hAx.XTickLabel;        % overwrite the existing tick labels with present values
set(gcf,'color','w');
ax = get(gca,'XTickLabel');
xticks('auto');
set(gca,'XTickLabel',ax,'FontName','Times','fontsize',12);
% ylim([min(NMSE_sim.ans) max(NMSE_str)*1.1]);