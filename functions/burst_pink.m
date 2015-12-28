function output = burst_pink(repeat_number, fs, low_freqenz, high_freqenz, gain_value, stereo, burst_time)
% repeat_number=3;fs=44100;low_freqenz=20;high_freqenz=20000,gain_values=200;stereo = 1;
%   usage: out = burst(4,44100,20,20000,20,1,3)
%------------------------------------------------------------------------------------------------------------
%   Input: 
%       repeat_number:  repeat burst number per second, I suggust 2 or 4 that
%                                1000 divided by 2 or 4 will be better
%       fs: sample rate 
%       audioIn: the input audio 
%       stereo:  ' 1 ' means stereo output, ' 0 ' means mono
%       burst_time: how many seconds willl the bust take, unit in second
%
%   Output:
%       out: stero oder mono burst output in second
%------------------------------------------------------------------------------------------------------------

% init factors, you can change those.
% calculate the each burst duration, one second / repeat_number will get
% the duration per burst
    single_burst_duration = 1 / repeat_number; 
    
% noise length = fade in + rest audios + fade out, 
% length = fs * time
    noise_length = floor(single_burst_duration / 2 * fs); % the noise length and pause are same, so divided by two
    pause_length = floor(single_burst_duration /2 * fs);
    fade_length = floor( single_burst_duration/2/10 * fs); % length of fade in or fade out is 1/10 of the noise length
    
% fade windows
    window = hann(fade_length*2);

% get the fade in and fade out window
    fade_in  = window(1:end/2);
    fade_out = window(end/2+1:end);

% each segment =  = fade in + rest audios + fade out + pause
    segment = [fade_in; ones(noise_length-2*fade_length,1); fade_out; zeros(pause_length,1)]; 

% init  out as a array;
    total_segment = [];

% start loop to calculate the total segment    
     for i = 1:repeat_number
         % repeat and get the burst
         total_segment = [total_segment; segment];
     end
     
% init burst array and repeat for burst_time times 
   burst = [];
     for i = 1:burst_time
         % repeat and get the burst
         burst = [total_segment; burst];
     end
        
%------------------------------------------------------------------------------------------------------------   
% pink noise generation

%     noise = rand(size(total_segment,1),1)-0.5; %here: generate pink noise!
%     a = zeros(1,size(noise,1));
%     a(1) = 1;
%     for i = 2:size(noise,1);
%         a(i) = (i-2.5) * a(i-1) / (i-1);
%     end
% 
%     pink = filter(1,a,noise);

% http://www.dsprelated.com/freebooks/sasp/Example_Synthesis_1_F_Noise.html
    Nx = size(burst,1);
    B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
    A = [1 -2.494956002   2.017265875  -0.522189400];
    nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.
    v = randn(1,Nx+nT60); % Gaussian white noise: N(0,1)
    pink = filter(B,A,v);    % Apply 1/F roll-off to PSD
    pink = pink(nT60+1:end);    % Skip transient response
    pink = pink';

%------------------------------------------------------------------------------------------------------------   
% band pass filter
    low  = low_freqenz/(fs/2);   % calculate the angle for pi
    high = high_freqenz/(fs/2);
    bandpass = fir1(256,[low high]);
    pinknoise = filter(bandpass,1,pink);
    output = burst .* pinknoise;
    
    % gain value
    gain = 10^(gain_value*20); 
    output = output * gain;

    if (stereo==1)
        output = [output,output];
    end

end

% write signal
% audiowrite('burst_pink.wav',output,fs);
%--------------------------------------------------------------------------
