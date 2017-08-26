function [model, Sname, Lpos, A, name] = grin2a_models(i)

switch i 
    case 1
        model(1).source='CMC';
        model(2).source='CMC';
        model(3).source='CMC';
        model(4).source='CMC';
        
        Sname = {'LF', 'RF', 'LP', 'RP'};
        Lpos  = [[-48; 13; 17] [49; 12; 17] [-46; -60; 33] [46; -59; 31]];
        
        Nareas = 4;
        
        I      = zeros(Nareas, Nareas);
        I(1,1) = 1; I(2,2) = 1; 
        I(3,3) = 1; I(4,4) = 1;

        L      = zeros(Nareas, Nareas);
        L(2,1) = 1; L(1,2) = 1; 
        L(4,3) = 1; L(3,4) = 1;

        F      = zeros(Nareas, Nareas);
        F(3,1) = 1; 
        F(4,2) = 1;

        B      = zeros(Nareas, Nareas);
        B(1,3) = 1;
        B(2,4) = 1;
        
        A{1} = F + L;
        A{2} = B + L;
        A{3} = I;
        
        name = 'noT';
        
    case 2
        model(1).source='CMC';
        model(2).source='CMC';
        model(3).source='CMC';
        model(4).source='CMC';
        model(5).source='ERP'; 
        
        Sname = {'LF', 'RF', 'LP', 'RP', 'TH'};
        Lpos  = [[-48; 13; 17] [49; 12; 17] [-46; -60; 33] [46; -59; 31] [300; 300; 300]];
        
        Nareas = 5;
        
        I      = zeros(Nareas, Nareas);
        I(1,1) = 1; I(2,2) = 1; 
        I(3,3) = 1; I(4,4) = 1; I(5,5); 

        L      = zeros(Nareas, Nareas);
        L(2,1) = 1; L(1,2) = 1; 
        L(4,3) = 1; L(3,4) = 1;

        F      = zeros(Nareas, Nareas);
        % cortical
        F(3,1) = 1; F(4,2) = 1; 
        % thalamic
        F(1,5) = 1; F(2,5) = 1; 
        F(3,5) = 1; F(4,5) = 1;

        B      = zeros(Nareas, Nareas);
        % cortical
        B(1,3) = 1; B(2,4) = 1; 
        % thalamic
        B(5,1) = 1; B(5,2) = 1; 
        B(5,3) = 1; B(5,4) = 1;

        
        A{1} = F + L;
        A{2} = B + L;
        A{3} = I;
        
        name = 'Th1';
        
    case 3
      	model(1).source='CMC';
        model(2).source='CMC';
        model(3).source='CMC';
        model(4).source='CMC';
        model(5).source='ERP'; 
        model(6).source='ERP';
        
        Sname = {'LF', 'RF', 'LP', 'RP', 'LT', 'RT'};
        Lpos  = [[-48; 13; 17] [49; 12; 17] [-46; -60; 33] [46; -59; 31] [300; 300; 300] [300; 300; 300]];
        
        Nareas = 6;
        
        I      = zeros(Nareas, Nareas);
        I(1,1) = 1; I(2,2) = 1; 
        I(3,3) = 1; I(4,4) = 1; 
        I(5,5) = 1; I(6,6) = 1; 

        L      = zeros(Nareas, Nareas);
        L(2,1) = 1; L(1,2) = 1; 
        L(4,3) = 1; L(3,4) = 1;

        F      = zeros(Nareas, Nareas);
        % cortical
        F(3,1) = 1; F(4,2) = 1; 
        % thalamic
        F(1,5) = 1; F(2,5) = 1;     % parietal thalamus
        F(3,6) = 1; F(4,6) = 1;     % frontal thalamus

        B      = zeros(Nareas, Nareas);
        % cortical
        B(1,3) = 1; B(2,4) = 1; 
        % thalamic
        B(5,1) = 1; B(5,2) = 1;     % parietal thalamus
        B(6,3) = 1; B(6,4) = 1;     % frontal thalamus
            
        A{1} = F + L;
        A{2} = B + L;
        A{3} = I;
        
        name = 'Th2';
        
    case 4
        
        model(1).source='CMC';
        model(2).source='CMC';
        model(3).source='CMC';
        model(4).source='CMC';
        model(5).source='ERP'; 
        model(6).source='ERP';
        
        Sname = {'LF', 'RF', 'LP', 'RP', 'LT', 'RT'};
        Lpos  = [[-48; 13; 17] [49; 12; 17] [-46; -60; 33] [46; -59; 31] [300; 300; 300] [300; 300; 300]];
        
        Nareas = 6;
        
        I      = zeros(Nareas, Nareas);
        I(1,1) = 1; I(2,2) = 1; 
        I(3,3) = 1; I(4,4) = 1; 
        I(5,5) = 1; I(6,6) = 1; 

        L      = zeros(Nareas, Nareas);
        L(2,1) = 1; L(1,2) = 1; 
        L(4,3) = 1; L(3,4) = 1;

        F      = zeros(Nareas, Nareas);
        % cortical
        F(3,1) = 1; F(4,2) = 1; 
        % thalamic
        F(1,5) = 1; F(2,6) = 1;     % left thalamus
        F(3,5) = 1; F(4,6) = 1;     % right thamalus

        B      = zeros(Nareas, Nareas);
        % cortical
        B(1,3) = 1; B(2,4) = 1; 
        % thalamic
        B(5,1) = 1; B(6,2) = 1;     % left thalamus
        B(5,3) = 1; B(6,4) = 1;     % right thalamus
            
        A{1} = F + L;
        A{2} = B + L;
        A{3} = I;
        
        name = 'Thm';
        
        
end

        