dirData = dir('*.mat');         %# Get the selected file data
fileNames = {dirData.name};     %# Create a cell array of file names
subject_number = [];
for k = 1:numel(fileNames)      %# Loop over the file names
    fileNames = natsort(fileNames);
    subject_number(k) = str2num(fileNames{k}(4));
    num2str(subject_number(k));
    next=str2num(fileNames{k}(5));
    if ~isempty(next)
         subject_number(k) = (10 + next);
    end
    
    for i=1:4
        cuttime = i;
        load(fileNames{k});
        if exist(sprintf('M3T%d_base_nrem_ds_%d',subject_number(k),i))
            nEEG_ds_cut = str2var(sprintf('M3T%d_base_nrem_ds_%d',subject_number(k),i));
        else
            nEEG_ds_cut = str2var(sprintf('M3T%d_pexpo_nrem_ds_%d',subject_number(k),i));
        end
        Morse_Automated_Detection_mousetype(nEEG_ds_cut, cuttime, subject_number(k)); %Write correct code name in "mousetype" ( "_s1" , "_bl6" ).
    end
end