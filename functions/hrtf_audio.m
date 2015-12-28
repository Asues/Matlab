function out = hrtf_audio(fn,brir,points_number,gain)
%   usage: out = hrtf_audio('piano48k.wav',6,10)
%------------------------------------------------------------------------------------------------------------
%   Input: 
%       fn: file name 
%       brir:   brir datebase, the number must DOUBLE EQUAL to points_number for each
%               sound segment. brir must so looks like:
%                           [L1 R1 L2 R2.......Ln Rn]    
%               with L and R have only one column!
%       points_number:  how many segement will be played in a circle
%       gain: gain value for the output
%
%   Output:
%       out: audio with hrtf in piece of "points_number" 

%------------------------------------function start------------------------------------------------------    

% read audio file
    [audioIn,fs] = audioread(fn);
    audioIn = audioIn';

    % get the length of the audio file
    duration = length(audioIn);

    % brir points for azimut in grad {300, 330, 0, 60, 120, 180} 
    % the numbers of the synthesis points

    % the number of padding zeros
    remainder = mod(duration,points_number); 

    if remainder > 0 % if the remainder not equal to zero,then calculate the padding zeros
        padding_zero = points_number - remainder;

        % padding zeros with audio file
        audioIn = [audioIn zeros(1,padding_zero) ];
    end    

    % caculate the new audio length and get a step length for each segment
    step = length(audioIn) / points_number; 

    % length for windos size
    window_N = 2048; 
    window = hann(window_N)';
   
    % pass filter
    lowpass=fir1(1000,20000/fs*2); %low pass filter with 20000Hz
    highpass = fir1(1000,20/fs*2,'high');  %high pass filter with 20Hz

%     % read brir  {300, 330, 0, 60, 120, 180}
%     BRIR = getTotalBRIR();
%     BRIR300 = BRIR(:,1:2);
%     BRIR330 = BRIR(:,3:4);
%     BRIR0 = BRIR(:,5:6);
%     BRIR60 = BRIR(:,7:8);
%     BRIR120 = BRIR(:,9:10);
%     BRIR180 = BRIR(:,11:12);
% 
%     % get a new BRIR array for each of the segment,(the number is equal to  points_number)
%     newBRIR = [ BRIR0 BRIR60  BRIR120 BRIR180 BRIR300 BRIR330];

    % init segment piece
    segment_L = zeros(points_number,step);
    segment_R = zeros(points_number,step);

    for i = 1 : points_number % because brir has only 6 points in Azimut   {300, 330, 0, 60, 120, 180}

    % faltung    
        L = filter(brir(:,2*i-1)',1,audioIn(1,step*(i-1)+1:step*i));
        R = filter(brir(:,2*i)',1,audioIn(1,step*(i-1)+1:step*i));

        segment_L(i,:) = L;
        segment_R(i,:) = R;

    end

    % audio with fade in and fade out

    for n = 1 : points_number

        % the last segment need only fade in, so we make that later, first make
        % fade in and fade out except the last segment
        % add fade in for each segment at the beginning
        segment_L(n,1:window_N/2) = segment_L(n,1:window_N/2) .* window(1:window_N/2);  
        segment_R(n,1:window_N/2) = segment_R(n,1:window_N/2) .* window(1:window_N/2); 

        %add fade out for each segment at the end
            segment_L(n,(end - window_N/2 + 1):end) = segment_L(n,(end - window_N/2 + 1):end) .* window((window_N/2+1):end); 
            segment_R(n,(end - window_N/2 + 1):end) = segment_R(n,(end - window_N/2 + 1):end) .* window((window_N/2+1):end);    
    end

    % calculattion: segment = fade in + audio + [fade out + fade in (from next
    % segment)], the first segment need only fade out, and the last segment need
    % only fade in, so we make that for 3 steps:

    % step 1:  for the first segments, we dont need fade in at the beginning
    % length: total piece length = step
     left = [segment_L(1,1:end - (window_N/2)) segment_L(1,(end - window_N/2 +1):end) + segment_L(2,1:(window_N/2))];  
     right = [segment_R(1,1:end - (window_N/2)) segment_R(1,(end - window_N/2 + 1):end) + segment_R(2,1:(window_N/2))];

    % init left and right
    % left_middle = zeros(points_number-1,step - window_N/2);
    % right_middle = zeros(points_number-1,step - window_N/2);

    % step 2: for the rest segments,except the last.
    % length: total piece - head = step - window_N/2
    for n = 2 : points_number - 1 % except the last segment
        left = [left segment_L(n,(window_N/2+1):end-(window_N/2)) segment_L(n,(end - window_N/2 + 1):end) + segment_L(n+1,1:(window_N/2))];
        right = [right segment_R(n,(window_N/2+1):end-(window_N/2)) segment_R(n,(end - window_N/2 + 1):end) + segment_R(n+1,1:(window_N/2))];
    end 

    % step 3: for the last segment:
    % length: total piece - head = step - window_N/2
    n = points_number;
    left = [left segment_L(n,(window_N/2 + 1):end)];
    right = [right segment_R(n,(window_N/2 + 1):end)];

    % find max value 
    max_value = max(abs([left right]));

    % normalization
    left = left / max_value;
    right = right / max_value;

    %filterung
    out_left = filter(lowpass,1,left);
    out_right = filter(lowpass,1,right);
    out_left = filter(highpass,1,out_left);
    out_right = filter(highpass,1,out_right);
    
    % output
    out = [out_left' out_right'];
    out = out * gain;
    % write the wav and play the audio
    audiowrite('hrtf_audio.wav',out,fs);
    output = audioplayer(out,fs);
    output.play;

end




