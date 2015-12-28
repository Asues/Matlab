function out = getHRIR(grad,leftOrRight)

    % init factor
    distance = 80; % {80 300}
    elevation = 0; % {-10 0 10 20}
    winkelanzahl = 360/5;
    azimuth = linspace(-180,180,winkelanzahl+1); % {-180 : 5 : 180}

    %init HRIR-matrix
    HRIR = zeros(4800,2*winkelanzahl);

    % start loading the HRIR
    cd('HRIR_database_mat'); % into the ordner
    for a = 1:(winkelanzahl+1)
        azi=azimuth(1,a);
        hrir = loadHRIR('Anechoic', distance, elevation, azi , 'in-ear');
        HRIR(:,a+a-1) = hrir.data(:,1);
        HRIR(:,a+a)   = hrir.data(:,2);
    end
    cd('..'); % exit the ordner
    
    startNumber = (grad/5)*2+1;
     switch leftOrRight
        case 'L'
            theValue = HRIR(:,startNumber); %% for left ear
        case 'l'
            theValue = HRIR(:,startNumber);
        case 'r'
            theValue = HRIR(:,startNumber+1); %% for right ear
         case 'R'
            theValue = HRIR(:,startNumber+1); 
         otherwise
          fprintf ('please enter the right channel \n');
    end
    out = theValue;
end