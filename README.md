# Bachelor-Thesis
Automated Sleep Spindle Detection
DATA HANDLING PROCEDURE
Open desired raw EEG recording (.smr) in Spike2.
Apply a low-pass filter. Open Analysis -> Digital Filters -> IIR Filters. Select Channel: EEG2. Select Filter: low pass fourth order. Click on show details. Model: Butterworth. Corner: 20. Order: 10. Click Apply. Click OK. 
Export EEG data. Open File -> Export As… . Create a data name for the signal. Select MATLAB data as file type. Select “Channel or channel list”: m1 Memory (created signal with low-pass filter). Click Add. Click Export. Mark “Align and bin all data at” and type the sampling rate (M3Tx EEG recordings have a sampling rate of 250 Hz) Click OK. 
Import EEG data into MATLAB and extract the signal. Click on data name. Import Wizard -> Click Finish. In the workspace, click the struct with 9 fields (M3Tx_xxxxxx_c5_Ch2001). Click once on the “values” field. Click “New from Selection”. The created vector should have the name “values”.
Import sleep scoring data into MATLAB. Open “Testdaten_M3”. Open “Auswertungen_Fritz Eva Maria”. Choose the same folder and subfolder names where raw EEG recording was taken from. Open Excel data (.xlsx). Open “Tabelle 1”. Choose the column D by clicking on column “D”. Press Ctrl+C. Return to MATLAB and click on a blank space of the workspace. Press Ctrl+V. Choose “Output Type”: Numeric Matrix. Click “Import Selection”. Change the name of the imported data into “epochdata”.
Extract NREMS signals. Open “nrem_merge” in MATLAB. Change the “x” in the “M3Tx” into correct number. Change the “type” into correct name (base, pexpo). Create a folder with the name “M3Tx”. Type “nrem_merge(values, epochdata)” into the Command Window.
Create an input folder. Put all extracted NREMS recordings into an “input folder”.
Open the detection program. Add the folder path of the folder where “Autorun” is found. Open “Autorun”. Open the “input folder” (“Curent Folder” of MATLAB should be the input folder). 
Choose the correct detection program for the mouse strain. For S1 strain, choose “Morse_Automated_Detection_s1”. For BL6 strain, choose “Morse_Automated_Detection_bl1”. Before running the program, change the output folder directory (once for the excel data output (code line 103), once for the plots (code line 125)). 
Run “Autorun”.
