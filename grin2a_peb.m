% Housekeeping
%==========================================================================
D       = grin2a_housekeeping('HC');
fs      = filesep;
    
Fbase       = D.Fbase;
Fscripts    = D.Fscripts;
Fdata       = D.Fdata;
Fmat        = [Fbase fs 'Matlab Files'];

% Load subject specific DCM files
%--------------------------------------------------------------------------
PCM = load([Fmat fs 'JS']);   PCM = PCM.ACM;  % models * sleep stages
HCM = load([Fmat fs 'HC']);   HCM = HCM.ACM;  % models * sleep stages

%%
ACM = {HCM{2,:}, PCM{2,:}};

X       = ones(length(ACM), 1);
M.X     = X;

[PEB RCM]   = spm_dcm_peb(ACM', M);

% %% Restructure DCM to allow PEB to run
% %==========================================================================
% 
% for i = 1:length(ACM)
% % Create empty structure arrays
% %--------------------------------------------------------------------------
% pE = ACM{i}.M.pE;
% pC = ACM{i}.M.pC;
% Ep = ACM{i}.Ep;
% Cp = spm_unvec(diag(ACM{i}.Cp), ACM{i}.Ep);
% 
% TCM{i}.M.pE.T = [];     TCM{i}.M.pC.T = [];
% TCM{i}.M.pE.G = [];     TCM{i}.M.pC.G = [];
% TCM{i}.M.pE.H = [];     TCM{i}.M.pC.H = [];
% 
% TCM{i}.Ep.T = [];       TCM{i}.Cp.T = [];
% TCM{i}.Ep.G = [];       TCM{i}.Cp.G = [];
% TCM{i}.Ep.H = [];       TCM{i}.Cp.H = [];
% 
% pE = ACM{i}.M.pE;
% pC = ACM{i}.M.pC;
% Ep = ACM{i}.Ep;
% Cp = spm_unvec(diag(ACM{i}.Cp), ACM{i}.Ep);
% 
% ti = 0;
% gi = 0;
% for n = 1:5 
% for t = 1:length(pE.int{n}.T);
%     ti = ti + 1;
%     TCM{i}.M.pE.T(ti)    = pE.int{n}.T(t);
%     TCM{i}.M.pC.T(ti)    = pC.int{n}.T(t);
%     TCM{i}.Ep.T(ti)      = Ep.int{n}.T(t);
%     TCM{i}.Cp.T(ti)      = Cp.int{n}.T(t);
% end
% for g = 1:length(pE.int{n}.G);
%     gi = gi + 1;
%     TCM{i}.M.pE.G(gi)    = pE.int{n}.G(g);
%     TCM{i}.M.pC.G(gi)    = pC.int{n}.G(g);
%     TCM{i}.Ep.G(gi)      = Ep.int{n}.G(g);
%     TCM{i}.Cp.G(gi)      = Cp.int{n}.G(g);
% end
% end
% 
% TCM{i}.M.pE.A = pE.A;
% TCM{i}.M.pC.A = pC.A;
% TCM{i}.Ep.A   = Ep.A;
% TCM{i}.Cp.A   = Cp.A;
% 
% TCM{i}.M.pE.H = pE.int{end}.H;
% TCM{i}.M.pC.H = pC.int{end}.H;
% TCM{i}.Ep.H   = Ep.int{end}.H;
% TCM{i}.Cp.H   = Cp.int{end}.H;
% 
% TCM{i}.F    = ACM{i}.F;
% TCM{i}.Cp   = diag(spm_vec(TCM{i}.Cp));
% end

%% Run PEB on restructured DCMs
%==========================================================================
M.X = ones(length(TCM),1);
AEB = spm_dcm_peb(TCM', M, 'A');
AN  = AEB.Pnames;

tofind = 'A{1}';

cells = strfind(AN, tofind);
indxs = find(~cellfun('isempty', cells));


%%


fields = {'A', 'G', 'T', 'H'};
ci = 0;
for i = 1:length(fields)
combs = combntns(fields, i);
for c = 1:size(combs,1)
    ci = ci+1
    allcombs(ci) = {combs(c,:)}
end
clear combs
end

clear F
X(:,1) = ones(length(TCM), 1);
X(:,2) = [0 0 0 0 1 1 1 1];
X(:,3) = [0 1 2 3 0 1 2 3];
X(:,4) = [0 -1 -2 -3 0 1 2 3];
% X(:,4) = [0 1 1 1 0 1 1 1];
M.X = X;

for f = 1 %:length(allcombs)
    allcombs{f}
    PEB(f)  = spm_dcm_peb(TCM', M, allcombs{f});
    F(f)    = PEB(f).F;
end
F = F - min(F);
F = F';

figure(1)
subplot(2,1,1)
    bar(F);
    up = sort(F);
    dF = up(end)-up(end-1);
    title(['Delta F = ' num2str(dF)]);

subplot(2,1,2)
    bar(spm_softmax(F))
%%

[Fwin iwin] = max(F);
[PEB RCM] = spm_dcm_peb(TCM', M, allcombs{iwin});
RMA          = spm_dcm_peb_bmc(PEB);
for i = 1:8
figure(1)
subplot(2,4,i)
    bar(RCM{i}.Ep.H)
    ylim([-0.4 0.4]);
end


