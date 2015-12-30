% HRTF
% Author: 	Hong Ma
% E-mail:   contact@mahong.org
% Created:    Dec 2015
% TU Ilmenau | IMT | Elektronische Medientechnik. 
%------------------------------------------------------------------------------------------------------------
clear;
fn = 'nokia.wav';
fs = 44100;
hrir_fn= 'hrir_final.mat';
front = 9;
back = 41;

% get the  HRIR for each ear
hrir_l = load_CIPIC_HRIR(hrir_fn,front,back,'left');
hrir_r = load_CIPIC_HRIR(hrir_fn,front,back,'right');

hrir_l = hrir_l';
hrir_r = hrir_r';

% get the total HRIR
hrir = [];
for i = 1:size(hrir_l,2)
    hrir(:,i*2-1) = hrir_l(:,i);
    hrir(:,i*2) =  hrir_r(:,i);
end    

% conv
out = audio_with_brir(fn,hrir);

% audio write
audiowrite('nokia_hrtf.wav',out,fs);