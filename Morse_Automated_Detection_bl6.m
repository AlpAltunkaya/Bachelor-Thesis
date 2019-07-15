function [all_data] = Morse_Automated_Detection_bl6(nEEG_ds_cut,cuttime,subject_number) % Only put NREM sorted, 20 Hz low pass filtered data with a frame rate of 50 Hz.
%% Turn NaN into 0.
nEEG_ds=nEEG_ds_cut;
EEG_ds = nEEG_ds;
EEG_ds(isnan(nEEG_ds_cut))=0;

%% Cut out Artifacts
fs=50;
EEG_ds(abs(EEG_ds)>1.2) = 0;
%% Wavelet Transform
[cfs,frq] = cwt(EEG_ds,'morse',fs);

%% Define 5-15 Hz Interval
frq_5=find(frq<=5);
frq_15=find(frq>=15);

%tms=(0:numel(EEG_ds)-1)/fs;
%% Edit CWT data
cfs1=cfs(frq_15(end,:):frq_5(1,:),1:size(EEG_ds,1));
%frq1=frq(frq_15(end,:):frq_5(1,:),1);

%% Find max values that are WITHIN the treshold intervall
maxvalue = max(abs(cfs1));
ss_tresh = find(maxvalue>=0.140266);

%% Assign start/end points of sleep spindles
cnt=1;
for a=1:length(ss_tresh)-1
    ss2=ss_tresh(a+1);
    ss1=ss_tresh(a);
    if (ss2-ss1)>1
        spindletime(cnt,2)=a;
        spindletime(cnt+1, 1)=a+1;
        cnt=cnt+1;
    end 
end
if ~exist('spindletime')
        return
end
ss_tresh1=ss_tresh.';
maxvalue1=maxvalue.';
spindletime(1,1)=1;
spindletime(size(spindletime,1),2)=size(ss_tresh1,1);

%% Set Detection Window Intervall
spindle_int=[];
ss_tresh_int=[];
cnt=1;
for i=1:size(spindletime,1)
    if spindletime(i,2)-spindletime(i,1)>=1 && spindletime(i,2)-spindletime(i,1)<=100
        spindle_int(cnt,1)=spindletime(i,1);
        spindle_int(cnt,2)=spindletime(i,2);
        ss_tresh_int(spindletime(i,1):spindletime(i,2),1)= ss_tresh1(spindletime(i,1):spindletime(i,2),1);
        cnt=cnt+1;
    end
end

%% NREMS Completion
count=1;
nrem_nan = find(~isnan(nEEG_ds));
for a=1:size(nrem_nan,1)-1
    idx1=nrem_nan(a);
    idx2=nrem_nan(a+1);
    if (idx2-idx1)>1
        nrem_sig(count,2)=a;
        nrem_sig(count+1, 1)=a+1;
        count=count+1;
    end
end
nrem_sig(1,1)=1;
nrem_sig(size(nrem_sig,1),2)=size(nrem_nan,1);
%% Correlate NREMS completion with sleep spindle
nrem_matrix=[];
for i=1:size(spindle_int,1)
    anfang_ss = ss_tresh_int(spindle_int(i,1),1);
    ende_ss = ss_tresh_int(spindle_int(i,2),1);
    for k=1:size(nrem_sig,1)
        anfang_nrem = nrem_nan(nrem_sig(k,1),1);
        ende_nrem = nrem_nan(nrem_sig(k,2),1);
        if anfang_nrem < anfang_ss && ende_nrem > ende_ss
            nrem_matrix(i,1)= ende_nrem-anfang_nrem;
            nrem_matrix(i,2)= ((anfang_ss+ende_ss)/2)-anfang_nrem;
        end
    end
end
nrem_completion=zeros(size(nrem_matrix,1),1);
for i=1:size(nrem_matrix,1)
    nrem_completion(i,1) = 100*nrem_matrix(i,2)/nrem_matrix(i,1);
end
%% Put all values into one matrix.
all_data =zeros(size(spindle_int,1),6);
for i=1:size(spindle_int,1)
    all_data(i,1)=i;
    all_data(i,2)=(ss_tresh_int(spindle_int(i,1),1))/fs;
    all_data(i,3)=(ss_tresh_int(spindle_int(i,2),1))/fs;
    all_data(i,4)=max(maxvalue1(ss_tresh_int(spindle_int(i,1):spindle_int(i,2),1)));
    all_data(i,5)=spindle_int(i,2)-spindle_int(i,1);
    all_data(i,6)=nrem_completion(i,1);
    all_data(i,7)=nrem_matrix(i,1)/fs;
end
cuttime_val=cuttime;
%%                                      CHANGE OUTPUT DIRECTORY!
xlswrite(['C:/Users/ALP/Desktop/lpf bl6_opt output/postexpo/Detection ','M3T',num2str(subject_number),' ',num2str(cuttime_val),'_',num2str(i)],all_data);
%% Timing

if cuttime == 1
    cuttime = 'First';
elseif cuttime == 2
    cuttime = 'Second';
elseif cuttime == 3
    cuttime = 'Third';
elseif cuttime == 4
    cuttime = 'Last';
end
    
%% Plot individual sleep spindles
for i=1:size(spindle_int,1)
    figure(i)
    tms = ((ss_tresh_int(spindle_int(i,1),1)-(2*fs-((ss_tresh_int(spindle_int(i,2),1)-ss_tresh_int(spindle_int(i,1),1))/2))):(ss_tresh_int(spindle_int(i,2),1)+((2*fs-((ss_tresh_int(spindle_int(i,2),1)-ss_tresh_int(spindle_int(i,1),1))/2)))))/fs;
    plot(tms,EEG_ds(((ss_tresh_int(spindle_int(i,1),1)-(2*fs-((ss_tresh_int(spindle_int(i,2),1)-ss_tresh_int(spindle_int(i,1),1))/2))):(ss_tresh_int(spindle_int(i,2),1)+((2*fs-((ss_tresh_int(spindle_int(i,2),1)-ss_tresh_int(spindle_int(i,1),1))/2))))),1))
    ylim([-0.8 0.8])
    title({['M3T',num2str(subject_number),' Detection: ',num2str(i)],['Detection Peak: ',num2str(max(maxvalue1(ss_tresh_int(spindle_int(i,1):spindle_int(i,2),1)))),'  Detection Window: ',num2str(spindle_int(i,2)-spindle_int(i,1))],['NREMS Completion: ',num2str(nrem_completion(i,1)),'%','  NREMS Duration: ',num2str(all_data(i,7)),' s']},'FontSize',10)
    xlabel(['{\bfTime [s]}  ','(',cuttime, ' quarter of recording)'])
    ylabel('{\bfVoltage [mV]}')
    saveas(gcf,['C:/Users/ALP/Desktop/lpf bl6_opt output/postexpo/Detection ','M3T',num2str(subject_number),' ',num2str(cuttime_val),'_',num2str(i),'.jpg']);
    %%                                   CHANGE OUTPUT DIRECTORY!
    close all
end
end
