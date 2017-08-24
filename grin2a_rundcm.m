clear all
% Housekeeping
%--------------------------------------------------------------------------
D       = grin2a_housekeeping('HC');
fs      = filesep;
    
Fbase       = D.Fbase;
Fmat        = [Fbase fs 'Matlab Files'];

subjects = {'JS', 'HC'};
for s = 2 %:length(subjects)
for model = 4 
for stage = 3:4 
    subject = subjects{s};
    disp([subject ' Model: ' num2str(model) '; Stage: ' num2str(stage)]);
    ACM{s,model,stage} = grin2a_dcm(subject, model, stage);
    save([Fmat fs 'ACM.mat'], 'ACM');
end
end

end
