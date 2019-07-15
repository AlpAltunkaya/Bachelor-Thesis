function nrem_merge(values, epochdata)
%% Repeat elements

sample_rate = 250;%Sample rate in Hz
epoch_time = 4;%Epoch time in seconds
epochreal = repelem(epochdata, sample_rate*epoch_time); %Repeats each element depending on the amount of values there are in a given epoch time times the sample rate.

%% Merge Epochs and Amplitudes

alldata = zeros(20700000,2); %create matrix
values(20700001:end) = []; %cut the end of EEG recording
alldata(:,1)= values(:); %put EEG recording in the first column
alldata(:,2) = epochreal(:); %put sleep scoring data in the second column
%% NREM Purification
nrem_EEG = nan(length(alldata),1); %create matrix with NaNs.
idx = find(alldata(:,2)==3); %identify intervals with NREMS epochs
nrem_EEG(idx) = alldata(idx,1); %put parts of EEG recording found in NREMS into NaN matrix.
%% Downsampling
nrem_EEG_ds=downsample(nrem_EEG,5); %Downsample from 250 Hz into 50 Hz.
%% CHANGE NAMES!
M3Tx_type_nrem_ds_1=nrem_EEG_ds(1:length(nrem_EEG_ds)/4); % cut the purified recording into 4 parts.
M3Tx_type_nrem_ds_2=nrem_EEG_ds((length(nrem_EEG_ds)/4)+1:length(nrem_EEG_ds)*2/4);
M3Tx_type_nrem_ds_3=nrem_EEG_ds((length(nrem_EEG_ds)*2/4)+1:length(nrem_EEG_ds)*3/4);
M3Tx_type_nrem_ds_4=nrem_EEG_ds((length(nrem_EEG_ds)*3/4)+1:length(nrem_EEG_ds));

%variables='EEG1', 'EEG2', 'EEG3', 'EEG4';
save('M3Tx/M3Txbase.mat','M3Tx_type_nrem_ds_1','M3Tx_type_nrem_ds_2','M3Tx_type_nrem_ds_3','M3Tx_type_nrem_ds_4');
end