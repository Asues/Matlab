function output = burst(repeat_number,fs,audioIn,stereo)
% repeat_number = 4; fs = 44100; stereo = 1;
% usage: out = burst(2,44100,yourAudioElement,0)
%------------------------------------------------------------------------------------------------------------
% Input: 
%       repeat_number:  repeat burst number per second, I suggust 2 or 4 that
%                                1000 divided by 2 or 4 will be better
%       fs: sample rate 
%       audioIn: the input audio 
%       stereo:  ' 1 ' means stereo output, ' 0 ' means mono
%------------------------------------------------------------------------------------------------------------
% Output:
%       out: stero oder mono burst output with audi in file
%------------------------------------------------------------------------------------------------------------

% init factors, you can change those.

% number_burst = n; %number of burst repetitions
%     level = 10^(level_dBFS*1/20); %0 dBFS is '1' and -inf dBFS is '0'  
%------------------------------------------------------------------------------------------------------------
% calculate the each burst duration, one second / repeat_number will get
% the duration per burst
    single_burst_duration = 1 / repeat_number; 
    
% noise length = fade in + rest audios + fade out, 
% length = fs * time
    noise_length = floor(single_burst_duration / 2 * fs); % the noise length and pause are same, so divided by two
    pause_length = floor(single_burst_duration /2 * fs);
    fade_length = floor( single_burst_duration/2/10 * fs); % length of fade in or fade out is 1/10 of the noise length
    burst_length = noise_length + pause_length;
%------------------------------------------------------------------------------------------------------------

%   fade windows
    window = hann(fade_length*2);


% get the fade in and fade out window
    fade_in  = window(1:end/2);
    fade_out = window(end/2+1:end);
    

% each segment =  = fade in + rest audios + fade out + pause
    segment = [fade_in; ones(noise_length-2*fade_length,1); fade_out; zeros(pause_length,1)]; 

% init  out as a array;
    out = [];

      % get the audio length   
    audio_duration = length(audioIn);
    
    % a pointer, that we know if the audio input weather can be excact divided by
    % burst length, if remainder not equel to zero, that means, the last
    % segment will be part of them used. think about 11 divid 4 is 2 mod 3, then know
    % remainder is 3, so that means the last part has only 3 values
    remainder = mod(audio_duration,burst_length); 
    
    % calculate the repeat number
    shoule_repeat_number = floor(audio_duration / burst_length);
  
    if remainder == 0
         for i = 1:shoule_repeat_number
             % repeat and get the burst
             out = [out; segment];
         end
    else
        for i = 1:shoule_repeat_number
             out = [out; segment];
        end
            out = [out; segment(1:remainder)];
    end
    
    
    if (stereo==1)
        out = [out,out];
    end
    
    gain = 10^(200*1/20); 
    % output
    output = out*gain;
%     output = out;
end

%write signal
% name=strcat('wN_pulses_',int2str(nr),'.wav');
% wavwrite(sig,fs,RE,name);

%--------------------------------------------------------------------------
