% Run DCM for whole scalp sleep data GRIN2A
%==========================================================================
% Housekeeping
%--------------------------------------------------------------------------
subject = 'HC';
D       = grin2a_housekeeping(subject);
fs      = filesep;
    
Fscripts    = D.Fscripts;
Fdata       = D.Fdata;
Fanalysis   = D.Fanalysis;
Fmeeg       = D.Fmeeg;
Fdcm        = D.Fdcm;
Fsplit      = D.Fsplit;

fn          = D.fname;
Dfile       = D.Dfile;

for i = 1:4
[model, Sname, Lpos, A, name] = grin2a_models(i);

% Specify options  
%==========================================================================
% Create DCM Struct and specify DCM.options 
%--------------------------------------------------------------------------
DCM.options.analysis    = 'CSD';   	% cross-spectral density 
DCM.options.model       = model;    % structure cannonical microcircuit (for now)
DCM.options.spatial    	= 'IMG';    % virtual electrode input   
DCM.options.Tdcm        = [1 10000];     % 1-10k ms 

DCM.xY.Hz           = 1:60;         % frequency range  
DCM.options.D       = 1;          	% frequncy bin, 1 =no downsampling
DCM.options.Nmodes  = 8;        	% cosine reduction components used 
DCM.options.han     = 0;            % no hanning 

DCM.options.lock    = 0;           	% lock the trial-specific effects  
DCM.options.multiC  = 0;            % multichannel effects  
DCM.options.location = 1;           % optmise location 
DCM.options.symmetry = 1;           % symmeterical dipoles

% Location priors for dipoles
%--------------------------------------------------------------------------
DCM.Sname = Sname;
DCM.Lpos  = Lpos;

% Specify neuronal models  
%==========================================================================
% specify connectivity matrices 
%--------------------------------------------------------------------------
Nareas      = length(DCM.Sname);

DCM.A       = A;
DCM.B{1}    = zeros(Nareas, Nareas);
DCM.C       = sparse(length(DCM.A{1}),0); 

% Specify priors
%--------------------------------------------------------------------------
[pE,pC]  = spm_dcm_neural_priors(DCM.A,DCM.B,DCM.C,model);

qEc   = pE.int{1};
qEc.T(1) = 4;
qEc.T(2) = 2;
qEc.G(3) = -2;

qE        = pE;
qE.int{1} = qEc;
qE.int{2} = qEc;
qE.int{3} = qEc; 
qE.int{4} = qEc;

DCM.M.pE = qE;
DCM.M.pC = pC;


% Fix location of forward model
%--------------------------------------------------------------------------
load(Dfile);
D.path                          = Dfile;
D.other.inv{end}.forward.vol    = 'C:\Users\rrosch\Dropbox\Research\tools\spm\canonical\single_subj_T1_EEG_BEM.mat';
save(Dfile, 'D');


% Run DCM for four different conditions
%==========================================================================
conds = {'AW', 'S1', 'S2', 'S3'};
for c = 1:4   
    DCM.xY.Dfile    = Dfile; 
    DCM.xU.X        = [c]';
    DCM.xU.name     = conds{c};
    DCM.options.trials = c;
    
    DCM.name    = [Fanalysis fs 'DCM_' name '_' conds{c} '.mat'];
    ACM{i,c}      = grin2a_spm_dcm_csd(DCM);
end
end


% DCMfiles = cellstr(spm_select('FPlist', Fanalysis, '^DCM'));
% for d = 1:length(DCMfiles)
%    ACM{d} = load(DCMfiles{d}); 
%    ACM{d} = ACM{d}.DCM;
%    F(d)   = ACM{d}.F;
% end
% Fs = [sum(F(9:12)), sum(F(1:4)), sum(F(5:8))]
% bar(spm_softmax(Fs'))
% 
% %%
% 
% cols = cbrewer('qual', 'Set1', 8);
% figure(3)
% 
% for i = 1:4
% subplot(2,1,1)
% plot(ACM{i}.Hz, squeeze(log(real(ACM{i}.Hc{1}(:,1,1)))), 'color', cols(i,:), 'Linewidth', 2); 
% hold on
% axis square
% 
% subplot(2,1,2)
% plot(ACM{i}.Hz, squeeze(log(real(ACM{i}.xY.y{1}(:,1,1)))), 'color', cols(i,:), 'Linewidth', 2);
% hold on
% axis square
% legend({'Awake', 'S1', 'S2', 'S3-4'});
% end
% 
% set(gcf, 'color', 'w');

  