% F-plot
%==========================================================================
% This function takes the relative free energies for models with and
% without a hidden thalamic source and plots them by sleep stage

% Housekeeping
%--------------------------------------------------------------------------
clear all
D       = grin2a_housekeeping('HC');
fs      = filesep;
    
Fbase       = D.Fbase;
Fscripts    = D.Fscripts;
Fdata       = D.Fdata;
Fmat        = [Fbase fs 'Matlab Files'];

% Load subject specific DCM files
%--------------------------------------------------------------------------
clear HCM PCM
HPath   = cellstr(spm_select('FPList', [Fmat fs 'HC' fs 'DCM'], '^DCM*'));
for h = 1:length(HPath)
    load(HPath{h});
    HCM{h} = DCM; 
    clear DCM
end
HCM = {HCM{13:16}; HCM{1:4}; HCM{5:8}; HCM{9:12}};

PPath   = cellstr(spm_select('FPList', [Fmat fs 'JS' fs 'DCM'], '^DCM*'));
for p = 1:length(PPath)
    load(PPath{p});
    PCM{p} = DCM; 
    clear DCM
end
PCM = {PCM{13:16}; PCM{1:4}; PCM{5:8}; PCM{9:12}};

for i = 1:4     % models
for k = 1:4     % sleep stages
    HF(i,k) = HCM{i,k}.F;   
    PF(i,k) = PCM{i,k}.F;
end
end

%% Bayesian model comparison
%==========================================================================
for h = 1:length(HCM)
    fname   = HCM{h}.name;
    seppos  = find(fname == '/'); if isempty(seppos), seppos = find(fname == '\'); end
    dotpos  = find(fname == '.');

    name                = fname(seppos(end)+1 : dotpos(end)-1);
    name(name == '_')   = ' ';
    label{h}            = name;
end


% Calculate free energy differences
%--------------------------------------------------------------------------
AF      = HF + PF;
F       = mean(AF,2);

% Plotting Routines
%--------------------------------------------------------------------------
subplot(2,1,1), 
    bar(F - min(F));
    title('Free Energy Differences')
    ylabel('Free Energy');

subplot(2,1,2), 
    bar(spm_softmax(F));
    xlabel('Model');
    ylabel('Posterior Probability');
    set(gca, 'XTick', [1:4], 'XTickLabel', label);
    
%% Copy winning models into combined structure
%--------------------------------------------------------------------------
[wval wind]     = max(F);

for p = 1:size(HCM,2)
    P{1,p} = HCM{wind,p};
    P{2,p} = PCM{wind,p};
end

save([Fmat fs 'Full_Inversions_Winner'], 'P');