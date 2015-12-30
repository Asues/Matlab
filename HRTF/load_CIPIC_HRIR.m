function out = load_CIPIC_HRIR(hrir_fn,front,back,left_or_right)
%------------------------------------------------------------------------------------------------------------
% usage: out = load_CIPIC_HRIR('hrir_final.mat',9 ,41,'left'); 
%               9 and 41 is the middle of a circle round the head
% Input: 
%     hrir_fn:  CIPIC HRIR Datebase filename
%     front: the number of the front side
%     back: the number of the back side
%     left_or_right: for the left ear or right ear
%
%  Output:
%    out: return a circle CIPIC HRIR database from given channel
% Author: 	Hong Ma
% E-mail:   contact@mahong.org
% Created:    Dec 2015
% TU Ilmenau | IMT | Elektronische Medientechnik. 
%------------------------------------------------------------------------------------------------------------
    load(hrir_fn);
    switch left_or_right
        case 'L'
        % take the front side and back side with flip.
        out = [squeeze(hrir_l(:,front,:));flip(squeeze(hrir_l(:,back,:)),1)]; % left ear
        case 'l'
            out = [squeeze(hrir_l(:,front,:));flip(squeeze(hrir_l(:,back,:)),1)]; % left ear
        case 'left'
            out = [squeeze(hrir_l(:,front,:));flip(squeeze(hrir_l(:,back,:)),1)]; % left ear
        case 'Left'
            out = [squeeze(hrir_l(:,front,:));flip(squeeze(hrir_l(:,back,:)),1)]; % left ear
        case 'LEFT'
            out = [squeeze(hrir_l(:,front,:));flip(squeeze(hrir_l(:,back,:)),1)]; % left ear
        otherwise    
            out = [squeeze(hrir_r(:,front,:));flip(squeeze(hrir_r(:,back,:)),1)]; % right ear
    end
end