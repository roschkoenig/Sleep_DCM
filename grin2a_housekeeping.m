function D = grin2a_housekeeping(subject)
fs  = filesep;
if strcmp(computer, 'MACI64')
    Fbase = '/Users/roschkoenig/Dropbox/Research/Friston Lab/1602 GRIN2A Code';
else 
    Fbase       = 'C:\Users\rrosch\Dropbox\Research\Friston Lab\1602 GRIN2A Code';
end

Fscripts    = [Fbase fs 'Scripts'];
Fdata       = [Fbase fs 'Data'];
Fanalysis   = [Fbase fs 'Matlab Files' fs subject];
Fmeeg       = [Fanalysis fs 'MEEG'];
Fdcm        = [Fanalysis fs 'DCM'];
Fsplit      = [Fdata fs 'Split'];

if subject == 'JS' 
    fname = 'PT'; 
    Dfile = [Fmeeg fs 'fffPT_meeg.mat'];
else
    fname = subject; 
    Dfile = [Fmeeg fs 'ffHC_meeg.mat']; 
end

addpath(genpath(Fscripts));

spm('defaults', 'eeg');

% Pack for exporting
%==========================================================================
D.Fbase         = Fbase;
D.Fscripts      = Fscripts;
D.Fdata         = Fdata;
D.Fanalysis     = Fanalysis;
D.Fmeeg         = Fmeeg;
D.Fdcm          = Fdcm;
D.Fsplit        = Fsplit;

D.fname         = fname;
D.Dfile         = Dfile;
