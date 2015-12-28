function out = getBRIR(grad,leftOrRight)
    load('brir.mat');
    winkelanzahl = 6; % {300, 330, 0, 60, 120, 180}
    % init
    BRIR = zeros( size(recordings.impulseResponse{1, 2},1),2*winkelanzahl);

    for i=(1:winkelanzahl)
        BRIR(:,i+i-1) = recordings.impulseResponse{i, 2}(:,1);
        BRIR(:,i+i) = recordings.impulseResponse{i, 2}(:,2);
    end
    
    BRIR300 = BRIR(:,1:2);
    BRIR330 = BRIR(:,3:4);
    BRIR0 = BRIR(:,5:6);
    BRIR60 = BRIR(:,7:8);
    BRIR120 = BRIR(:,9:10);
    BRIR180 = BRIR(:,11:12);
   
    switch grad
         case 0
             if leftOrRight == 'l'
                theValue = BRIR0(:,1);  %% for left ear
             else
                 theValue = BRIR0(:,2);
             end   
        case 60
             if leftOrRight == 'l'
                theValue = BRIR60(:,1);  %% for left ear
             else
                 theValue = BRIR60(:,2);
             end   
         case 120
             if leftOrRight == 'l'
                theValue = BRIR120(:,1);  %% for left ear
             else
                theValue = BRIR120(:,2);
             end   
         case 180
             if leftOrRight == 'l'
                theValue = BRIR180(:,1);  %% for left ear
             else
                 theValue = BRIR0(:,2);
             end   
         case 300
             if leftOrRight == 'l'
                theValue = BRIR300(:,1);  %% for left ear
             else
                 theValue = BRIR330(:,2);
             end   
         case 330
             if leftOrRight == 'l'
                theValue = BRIR330(:,1);  %% for left ear
             else
                 theValue = BRIR330(:,2);
             end   
        otherwise
            fprintf ('please enter the right channel \n');
    end
        out = theValue;
end