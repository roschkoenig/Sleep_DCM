% F-plot
%==========================================================================
% This function takes the relative free energies for models with and
% without a hidden thalamic source and plots them by sleep stage

% Housekeeping
%--------------------------------------------------------------------------
D       = grin2a_housekeeping('HC');
fs      = filesep;
    
Fbase       = D.Fbase;
Fscripts    = D.Fscripts;
Fdata       = D.Fdata;
Fmat        = [Fbase fs 'Matlab Files'];

% Load subject specific DCM files
%--------------------------------------------------------------------------
clear HCM PCM
HPath   = cellstr(spm_select('FPList', [Fmat fs 'JS' fs 'DCM'], '^DCM*'));
for h = 1:length(HPath)
    load(HPath{h});
    HCM{h} = DCM; 
    clear DCM
end
HCM = {HCM{1:4}; HCM{5:8}; HCM{9:12}; HCM{13:16}};

PPath   = cellstr(spm_select('FPList', [Fmat fs 'HC' fs 'DCM'], '^DCM*'));
for p = 1:length(PPath)
    load(PPath{p});
    PCM{p} = DCM; 
    clear DCM
end
PCM = {PCM{1:4}; PCM{5:8}; PCM{9:12}; PCM{13:16}};

for i = 1:4     % models
for k = 1:4     % sleep stages
    HF(i,k) = HCM{i,k}.F;   
    PF(i,k) = PCM{i,k}.F;
end
end

% Plotting Routines
%==========================================================================

AF      = HF + PF;
F       = mean(AF,2);

subplot(2,1,1), bar(F - min(F));
subplot(2,1,2), bar(spm_softmax(F));



% % Setup
% %--------------------------------------------------------------------------
% cols    = cbrewer('qual', 'Set1', 10);
% colpst  = cbrewer('qual', 'Pastel1', 10);
% jscale  = 5;                     	% Scales down amount of x-axis jitter
% 
% % Healthy control free energies
% %--------------------------------------------------------------------------
% xjitter = (1:4)+(rand(1,4)-.5)/jscale;
% plot(xjitter, H_BF, 'color', colpst(1,:), 'linewidth', 2); hold on
% scatter(xjitter, H_BF, 150, cols(1,:), 'filled'); 
% 
% % Patient free energies
% %--------------------------------------------------------------------------
% xjitter = (1:4)+(rand(1,4)-.5)/jscale;
% plot(xjitter, P_BF, 'color', colpst(2,:), 'linewidth', 2)
% scatter(xjitter, P_BF, 150, cols(2,:),  'filled')
% 
% % Settings
% %--------------------------------------------------------------------------
% xlim([0 5]);
% plot([0 5], [0 0], 'color', [.5 .5 .5])
% hold off
% 
% % Labels
% %--------------------------------------------------------------------------
% xlabel('Sleep Stage');
% set(gca, 'XTick', 1:4, 'XTickLabel', {'Awake', 'N1', 'N2', 'N3'});
% 
% ylabel('Free Energy Difference')
% set(gca, 'YTick', [-3000 3000], 'YTickLabel', {'Th', 'No Th'});