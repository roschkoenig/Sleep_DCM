
% Housekeeping
%==========================================================================
% Manual Definitions
%--------------------------------------------------------------------------
subject = 'HC';
win     = 10;

% File structures
%--------------------------------------------------------------------------
fs          = filesep;
Fbase       = 'D:\Research_Data\1608 GRIN2A Micha MSc\Whole Scalp';
Fscripts    = [Fbase fs 'Scripts'];
Fdata       = [Fbase fs 'Data'];
Fanalysis   = [Fbase fs 'Matlab Files' fs subject];
addpath(Fscripts);

file    = [Fdata fs subject '.edf'];
hdr         = ft_read_header(file);
starts      = grin2a_starts(subject);
timeaxis    = linspace(0, win, win*hdr.Fs);

if subject == 'JS', fn = 'PT'; 
else fn = subject; end

fname    = [Fanalysis fs 'MEEG' fs fn '_meeg'];
ftdata.fsample  = hdr.Fs;
conds    = {'AW', 'S1', 'S2', 'S3'};
cn       = [];
count    = 0;

for s = 1:length(starts)
for ss = 1:length(starts{s})
    count = count + 1;
    bs = starts{s}(ss) * hdr.Fs;
    es = bs + win * hdr.Fs;
    cn = [cn; conds{s}];
    ftdata.trial{count} = ft_read_data(file, 'begsample', bs, 'endsample', es);
    ftdata.time{count}  = timeaxis;
end 
end

if subject == 'JS'
for l = 1:length(hdr.label)
    lbl{l,1} = hdr.label{l};
end;

else
    el = {  'Fp1', 'Fp2', 'F3', 'F4', 'C3', 'C4', 'P3', 'P4', 'O1', 'O2', 'F7' ...
            'F8', 'T3', 'T4', 'T5', 'T6', 'A1', 'A2', 'Fz', 'Cz', 'Pz'};
    for e = 1:length(el)
        temp        = strfind(hdr.label, el{e});
        idx         = find(~cellfun(@isempty, temp));
        lbl{idx}    = el{e};
    end

    for f = 1:length(ftdata.trial)
        clear temp
        temp = ftdata.trial{f}(1:length(lbl), :);
        ftdata.trial{f} = [];
        ftdata.trial{f} = temp;
        
        ftdata.trial{f} = ft_preproc_rereference(ftdata.trial{f});
    end
end

ftdata.label = lbl;
ftdata.label = ftdata.label(:);



D = spm_eeg_ft2spm(ftdata, fname);
D = type(D, 'single'); 
for c = 1:length(cn)
    D = conditions(D, c, {cn(c,:)});
end;

S = [];
S.task = 'defaulteegsens';
S.D = D;
D = spm_eeg_prep(S);
save(D);

S = [];
S.band  = 'bandpass';
S.freq  = [1 50];
S.D     = D;
D = spm_eeg_filter(S);

S = [];
S.band  = 'stop';
S.freq  = [49 52];
S.D     = D;
D = spm_eeg_filter(S);
