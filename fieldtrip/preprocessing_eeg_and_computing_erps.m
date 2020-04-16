%%%%% Preprocessing of EEG data and computing ERPs %%%%%%%%%%%%%%%%%%%%%%%
%
%  http://www.fieldtriptoolbox.org/tutorial/preprocessing_erp/
%
%  files located on local home pc at: 
%  D:\OneDrive\Documents\PhD @ FAU\research\fieldtrip_tuts\preprocessing_erp
%  online at:
%  ftp://ftp.fieldtriptoolbox.org/pub/fieldtrip/tutorial/preprocessing_erp/
%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%load data and use trialfun_affcog to identify segments of data used for
%further processing and analysis. stored in resulting cfg.trl matrix
cfg              = [];
cfg.trialfun     = 'trialfun_affcog';
cfg.headerfile   = 's04.vhdr';
cfg.datafile     = 's04.eeg';
cfg = ft_definetrial(cfg);

%cfg.trl has 4 columns. first is the begin sample, second the end sample, 
%third the offset and fourth contains condition for each trial 
%(1=affective, 2=ontological).