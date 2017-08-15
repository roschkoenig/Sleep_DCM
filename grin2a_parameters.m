% Housekeeping
%==========================================================================
% File structures
%--------------------------------------------------------------------------
spm('defaults', 'eeg') 
fs          = filesep;

if strcmp(computer, 'MACI64');
    Fbase = '/Users/roschkoenig/Dropbox/Research/Friston Lab/1602 GRIN2A Code';
else 
    Fbase       = 'D:\Research_Data\1608 GRIN2A Micha MSc\Whole Scalp';
end

clear files
count = 0;
subs = {'HC', 'JS'};

for s = 1:length(subs) 
    subject = subs{s};
    Fscripts    = [Fbase fs 'Scripts'];
    Fdata       = [Fbase fs 'Data'];
    Fanalysis   = [Fbase fs 'Matlab Files' fs subject];
    Fmeeg       = [Fanalysis fs 'MEEG'];
    Fdcm        = [Fanalysis fs 'DCM'];
    Fsplit      = [Fdata fs 'Split'];
    addpath(Fscripts);

    if subject == 'JS', fn = 'PT'; 
    else fn = subject; end

    thesefiles = cellstr(spm_select('FPList', Fdcm, '^DCM'));
    for t = 1:length(thesefiles)
        count = count + 1;
        files{count} = thesefiles{t};
    end
end

for f = 1:length(files)
    clear DCM
    load(files{f});
    ACM{f} = DCM;
end


%% Plot model predictions (first principal eigenmode)
%==========================================================================
figure(1)

cols = flip(cbrewer('div', 'Spectral', 10));
for i = 1:4
    subplot(2,2,1)
        plot(log(real(ACM{i}.xY.y{1}(:,1,1))), 'color', cols(i,:)); hold on
        axis square
        xlim([0 Inf])
        title('observed')
    subplot(2,2,3)
        plot(log(real(ACM{i}.Hc{1}(:,1,1))), 'color', cols(i,:)); hold on
        axis square
        xlim([0 Inf])
        title('predicted');
        xlabel('Healthy Control EEG', 'Fontsize', 12, 'Fontweight', 'bold')
        
    subplot(2,2,2)
        plot(log(real(ACM{i+4}.xY.y{1}(:,1,1))), 'color', cols(i,:)); hold on
        axis square
        xlim([0 Inf])
        title('observed')
    subplot(2,2,4)
        plot(log(real(ACM{i+4}.Hc{1}(:,1,1))), 'color', cols(i,:)); hold on
        axis square
        xlim([0 Inf])
        title('predicted');
        xlabel('Patient EEG', 'Fontsize', 12, 'Fontweight', 'bold')
end
subplot(2,2,4), legend({'Awake', 'Stage 1', 'Stage 2', 'Stage 3'});

%% Plot example time traces (Pz channel)
%==========================================================================

figure(2)
cond    = 'GRIN2A Patient';
D       = spm_eeg_load([Fbase fs 'Matlab Files' fs 'JS' fs 'MEEG' fs 'fffPT_meeg.mat']);
Cz      = 13;
aw      = D(Cz,:,1);
s1      = D(Cz,:,25);
s2      = D(Cz,:,44);
s3      = D(Cz,:,65);

% cond  = 'Control'
% D     = spm_eeg_load([Fbase fs 'Matlab Files' fs 'HC' fs 'MEEG' fs 'ffHC_meeg.mat']);
% Cz    = find(strcmp(chanlabels(D), 'Cz'));
% aw    = D(Cz,:,1);
% s1    = D(Cz,:,16);
% s2    = D(Cz,:,28);
% s3    = D(Cz,:,44);

time = linspace(0,10,length(aw));

subplot(4,1,1), plot(time, aw, 'color', cols(1,:)); ylim([-200 200]); xlim([1 Inf]); title(cond)
subplot(4,1,2), plot(time, s1, 'color', cols(2,:)); ylim([-200 200]); xlim([1 Inf]);
subplot(4,1,3), plot(time, s2, 'color', cols(3,:)); ylim([-200 200]); xlim([1 Inf]);
subplot(4,1,4), plot(time, s3, 'color', cols(4,:)); ylim([-200 200]); xlim([1 Inf]);
xlabel('Time');

%% Extract parameter ranges for intrinsic thalamic coupling
%==========================================================================
clear F X
X(:,1) = ones(length(TCM), 1);
X(:,2) = [0 0 0 0 1 1 1 1];
X(:,3) = [0 1 2 3 0 1 2 3];
X(:,4) = [0 1 1 1 0 1 1 1];

M.X         = X;
[PEB RCM]   = spm_dcm_peb(TCM', M, 'H');

Cp = spm_unvec(diag(PEB.Cp/2), PEB.Ep);

for p = 2:size(X,2)
subplot(1,size(X,2)-1,p-1)
    spm_plot_ci(PEB.Ep(:,p), Cp(:,p));
    ylim([-0.4 0.6]);
end

%%
Hz = ACM{1}.Hz;
thr = 25;

for s = 1:4
    stage{s,1} = ACM{s}.xY.y{1};
    stage{s,2} = ACM{s+4}.xY.y{1};
    
    s1 = real(stage{s,1}(:,1,1));
    s2 = real(stage{s,2}(:,1,1));

    hi = find(Hz > thr);
    lo = intersect(find(Hz <= thr), find(Hz > 1));
    
    rat(s,1) = log(mean(s1(hi)));
    rat(s,2) = log(mean(s2(hi)));
end

for c = 1:2
for a = 1:4
DCM = ACM{a+(c-1)*4};

% predictions (csd) and error (sensor space)
%--------------------------------------------------------------------------
Hc  = spm_csd_mtf(DCM.Ep,ACM{1}.M);                      % prediction
mde = real(squeeze(Hc{1}(:,1,1)));

rt(a,c)  = log(mean(mde(hi)));
end
end

dif = mean(mean(rat)) - mean(mean(rt));
rtn = rt + dif;

figure(2)
subplot(2,1,1), bar(rat);
subplot(2,1,2), bar(rtn);

%% Simulations
% Manual definitions
%--------------------------------------------------------------------------
for r = 1:8
    EH(r,:) = RCM{r}.Ep.H;
end

hs      = [1 4];
steps   = 10;
thr     = 30;

hi = find(Hz > thr);
lo = find(Hz <= thr);

clear p1r p2r DCM rtmap
for c = 1:2
for h = 1:4
    lower = min(EH(:, h));
    lower = lower - 0.1 * abs(lower);
    upper = max(EH(:, h));
    upper = upper + 0.1 * abs(upper);
    
    Hr{h,c} = linspace(lower, upper, steps);
end
end

for c = 1:2

p1r{c} = Hr{hs(1),c};
p2r{c} = Hr{hs(2),c};

for p1 = 1:length(p1r{c})
p1
for p2 = 1:length(p2r{c})   
    DCM = ACM{1 + (c-1)*4};
    DCM.Ep.int{end}.H(hs(1)) = p1r{c}(p1);
    DCM.Ep.int{end}.H(hs(2)) = p2r{c}(p2);
    
    Hc  = spm_csd_mtf(DCM.Ep,ACM{1}.M); 
    mde = real(squeeze(Hc{1}(:,1,1)));
    
    rtmap{c}(p1, p2)  = mean((mde(lo)));    
end
end
rtmap{c} = rtmap{c};
end
%%
subplot(2,1,1), 
    imagesc(p1r{1}, p2r{1}, rtmap{1}); hold on
    
    colormap(cols(1:4,:))
    axis square
    for a = 1:4
        scatter(EH(a,hs(1)), EH(a,hs(2)), 100, cols(a,:), 'filled');
    end
    
subplot(2,1,2), imagesc(p1r{2}, p2r{2}, rtmap{2}); hold on 
    for a = 1:4
        scatter(EH(a+4,hs(1)), EH(a+4,hs(2)), 100, cols(a,:), 'filled');
    end
    axis square
