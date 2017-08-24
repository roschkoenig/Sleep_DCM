function DCM = grin2a_dcm(subject, model_i, stage_i)

% Run DCM for whole scalp sleep data GRIN2A
%==========================================================================
% Housekeeping
%--------------------------------------------------------------------------
D       = grin2a_housekeeping(subject);
fs      = filesep;
    
Fbase       = D.Fbase;
Fmat        = [Fbase fs 'Matlab Files'];
Fscripts    = D.Fscripts;
Fdata       = D.Fdata;
Fanalysis   = D.Fanalysis;
Fmeeg       = D.Fmeeg;
Fdcm        = D.Fdcm;
Fsplit      = D.Fsplit;

fn          = D.fname;
Dfile       = D.Dfile;

i = model_i;
[model, Sname, Lpos, A, name] = grin2a_models(i);

% Specify options  
%==========================================================================
% Create DCM Struct and specify DCM.options 
%--------------------------------------------------------------------------
DCM.options.analysis    = 'CSD';   	% cross-spectral density 
DCM.options.model       = model;    % structure cannonical microcircuit (for now)
DCM.options.spatial    	= 'IMG';    % virtual electrode input   
DCM.options.Tdcm        = [1 10000];     % 1-10k ms 

DCM.xY.Hz           = 2:30;         % frequency range  
DCM.options.D       = 1;          	% frequncy bin, 1 =no downsampling
DCM.options.dur     = 16; 
DCM.options.Nmodes  = 8;        	% cosine reduction components used 
DCM.options.han     = 0;            % no hanning 
DCM.options.Fdcm    = [DCM.xY.Hz(1) DCM.xY.Hz(end)];

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

qEc      = pE.int{1};
qEc.T(1) = 4;
qEc.T(2) = 2;
qEc.G(3) = -2;

qE        = pE;
for i = 1:length(qE.int)
    if i <= 4,  qE.int{i}       = qEc;
    else,       qE.int{i}.T(2)  = -1; 
    end
end
   
DCM.M.pE = qE;
DCM.M.pC = pC;


% Fix location of forward model
%--------------------------------------------------------------------------
load(Dfile);
D.path                          = Dfile;
spmpath                         = which('spm');     
fspos                           = find(spmpath == fs);
spmpath                         = spmpath(1:fspos(end)-1);
D.other.inv{end}.forward.vol    = [spmpath fs 'canonical' fs 'single_subj_T1_EEG_BEM.mat'];
save(Dfile, 'D');


% Run DCM for four different conditions
%==========================================================================
conds   = {'AW', 'S1', 'S2', 'S3'};
c       = stage_i;

DCM.xY.Dfile    = Dfile; 
DCM.xU.X        = [c]';
DCM.xU.name     = conds{c};
DCM.options.trials = c;

DCM.name    = [Fdcm fs 'DCM_' name '_' conds{c} '.mat'];
DCM         = grin2a_spm_dcm_csd(DCM);