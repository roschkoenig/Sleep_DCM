% grin2a_datasplit

%% Run DCM for whole scalp sleep data GRIN2A
%==========================================================================
% Housekeeping
%==========================================================================
spm('defaults', 'eeg') 
fs          = filesep;
Fbase       = 'D:\Research_Data\1608 GRIN2A Micha MSc\Whole Scalp';
Fscripts    = [Fbase fs 'Scripts'];
Fdata       = [Fbase fs 'Data'];
Fanalysis   = [Fbase fs 'Matlab Files'];
Fdcm        = [Fanalysis fs 'DCM'];
Fsplit      = [Fdata fs 'Split'];
addpath(Fscripts);

% Set up DCM parameters
%==========================================================================
Dfile   = [Fdata fs 'fffPT_meeg.mat'];
D       = spm_eeg_load(Dfile);
condlist   = conditions(D);
conds   = unique(condlist);

%%
for t = 1%:size(D,3)
    bad     = ones(size(D,3),1);
    bidx    = 1:size(D,3);
    bad(t)  = 0;
    
    if t < 10; idxstr = ['0' num2str(t)];
    else idxstr = num2str(t); end
    
    condname = conditions(D,t);
    name = [condname{1} '_' idxstr];
   
    B = D;
    B = path(B,Fsplit);
    B = fname(B,name);
    
    B = badtrials(B,bidx,bad);
    
    S.D         = B;
    S.prefix    = '';
    B           = spm_eeg_remove_bad_trials(S);
end
    
