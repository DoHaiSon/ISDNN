unstr_4l = importdata('C:\Users\SON\Desktop\ISDNN\Python\Unstructured\model_10k_4l\H_log.txt');
str_4l   = importdata('C:\Users\SON\Desktop\ISDNN\Python\Structured\model_10k_4l\H_log.txt');
unstr_5l = importdata('C:\Users\SON\Desktop\ISDNN\Python\Unstructured\model_10k_5l_1\H_log.txt');
str_5l   = importdata('C:\Users\SON\Desktop\ISDNN\Python\Structured\model_10k_5l\H_log.txt');

epoch_unstr_4l = unstr_4l(:, 1);
NMSE_unstr_4l  = unstr_4l(:, 2);
Loss_unstr_4l  = unstr_4l(:, 3);

epoch_str_4l = str_4l(:, 1);
NMSE_str_4l  = str_4l(:, 2);
Loss_str_4l  = str_4l(:, 3);

epoch_unstr_5l = unstr_5l(:, 1);
NMSE_unstr_5l  = unstr_5l(:, 2);
Loss_unstr_5l  = unstr_5l(:, 3);

epoch_str_5l = str_5l(:, 1);
NMSE_str_5l  = str_5l(:, 2);
Loss_str_5l  = str_5l(:, 3);

semilogy(epoch_unstr_4l, Loss_unstr_4l, '-o', 'LineWidth', 1.5, 'Color', "#FF0000", 'MarkerSize', 7, 'MarkerFaceColor', "#FFFF00", 'MarkerIndices', 1:5:length(epoch_unstr_4l));
hold on;
semilogy(epoch_str_4l, Loss_str_4l, '-o', 'LineWidth', 1.5, 'Color', "#7E2F8E", 'MarkerSize', 5, 'MarkerFaceColor', "#FFFF00", 'MarkerIndices', 1:5:length(epoch_str_4l));
semilogy(epoch_unstr_5l, Loss_unstr_5l, '--^', 'LineWidth', 1.5, 'Color', "#0072BD", 'MarkerSize', 7, 'MarkerFaceColor', "#FFFF00", 'MarkerIndices', 1:5:length(epoch_unstr_5l));
semilogy(epoch_str_5l, Loss_str_5l, '--^', 'LineWidth', 1.5, 'Color', "#77AC30", 'MarkerSize', 5, 'MarkerFaceColor', "#FFFF00", 'MarkerIndices', 1:5:length(epoch_str_5l));

grid minor;
ylabel('Loss', 'FontSize', 14, 'Interpreter','latex');
xlabel('Iterations', 'FontSize', 14, 'Interpreter','latex');
legend('ISDNN: 4 layers', 'S-ISDNN: 4 layers', 'ISDNN: 5 layers', 'S-ISDNN: 5 layers', ...
    'Interpreter', 'latex', 'FontSize', 14, 'Edgecolor', 'white');
hAx=gca;                              % get the axes handle
hAx.XTickLabel=hAx.XTickLabel;        % overwrite the existing tick labels with present values
set(gcf,'color','w');
ax = get(gca,'XTickLabel');
xticks('auto');
set(gca,'XTickLabel',ax,'FontName','Times','fontsize',12);
