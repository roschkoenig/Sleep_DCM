% Housekeeping
%--------------------------------------------------------------------------
D       = grin2a_housekeeping('HC');
fs      = filesep;
    
Fscripts    = D.Fscripts;
Fdata       = D.Fdata;
Fanalysis   = D.Fanalysis;


PCM = load('JS');   PCM = PCM.ACM;  % sleep stages * models
HCM = load('HC');   HCM = HCM.ACM;  % sleep stages * models
%% 

for i = 1:4     % sleep stages
for k = 1:4     % models
    HF(i,k) = HCM{i,k}.F;   
    PF(i,k) = PCM{i,k}.F;
end
end

% Free energy difference between (1) No thalamus, and (2) Thalamus models
%--------------------------------------------------------------------------
H_BF = HF(1,:) - HF(2,:);
P_BF = PF(1,:) - PF(2,:);

% Plotting Routines
%==========================================================================
% Setup
%--------------------------------------------------------------------------
cols    = cbrewer('qual', 'Set1', 10);
colpst  = cbrewer('qual', 'Pastel1', 10);
jscale  = 5;                     	% Scales down amount of x-axis jitter

% Healthy control free energies
%--------------------------------------------------------------------------
xjitter = (1:4)+(rand(1,4)-.5)/jscale;
plot(xjitter, H_BF, 'color', colpst(1,:), 'linewidth', 2); hold on
scatter(xjitter, H_BF, 150, cols(1,:), 'filled'); 

% Patient free energies
%--------------------------------------------------------------------------
xjitter = (1:4)+(rand(1,4)-.5)/jscale;
plot(xjitter, P_BF, 'color', colpst(2,:), 'linewidth', 2)
scatter(xjitter, P_BF, 150, cols(2,:),  'filled')

% Settings
%--------------------------------------------------------------------------
xlim([0 5]);
plot([0 5], [0 0], 'color', [.5 .5 .5])
hold off

% Labels
%--------------------------------------------------------------------------
xlabel('Sleep Stage');
set(gca, 'XTick', 1:4, 'XTickLabel', {'Awake', 'N1', 'N2', 'N3'});

ylabel('Free Energy Difference')
set(gca, 'YTick', [-3000 3000], 'YTickLabel', {'Th', 'No Th'});