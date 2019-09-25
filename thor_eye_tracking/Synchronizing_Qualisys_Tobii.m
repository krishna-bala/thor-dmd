% Tobii recording011 starttime: 13:34:37.267
load('THORDatasetRecording011Filtered20190918.mat') %Tobii data from recording011
load('Ex_1_run_1.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 13:35:06.979
load('Ex_1_run_2.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 13:42:48.565
load('Ex_1_run_3.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 13:50:24.577
load('Ex_1_run_4.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 13:56:04.817
load('Ex_2_run_1.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 14:05:57.353
load('Ex_2_run_2.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 14:13:13.271
load('Ex_2_run_3.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 14:21:36.318
load('Ex_2_run_4.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 14:28:49.215

% Tobii recording012 starttime: 14:36:17.730
load('THORDatasetRecording012Filtered20190918.mat') %Tobii data from recording012
load('Ex_2_run_5.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 14:36:20.361
load('Ex_3_run_1.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 14:47:29.645
load('Ex_3_run_2.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 14:53:59.289
load('Ex_3_run_3.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 14:59:42.622
load('Ex_3_run_4.mat'); %Qualisys data - TIME_STAMP	2019-02-22, 15:05:16.236

%% Processing Ex_1_run_1

ex_1_run_1_startTime = hours(13) + minutes(35) + seconds(06) + milliseconds(979); % in hours
ex_1_run_1_startTime_ms = milliseconds(ex_1_run_1_startTime); % in milliseconds

ex_1_run_1_pos = squeeze(Experiment_1_run_1_0050.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_1_run_1_pos = ex_1_run_1_pos';
ex_1_run_1_rpy = squeeze(Experiment_1_run_1_0050.RigidBodies.RPYs(10,:,:));
ex_1_run_1_rpy = ex_1_run_1_rpy';
ex_1_run_1_timeStamp = [0.01: 0.01: length(ex_1_run_1_pos)/100]' + ex_1_run_1_startTime_ms;

ex_1_run_1_data = [ex_1_run_1_timeStamp ex_1_run_1_pos ex_1_run_1_rpy]; %[TimeStamp,x,y,z,r,p,y]

%% Processing Ex_1_run_2

ex_1_run_2_startTime = hours(13) + minutes(42) + seconds(48) + milliseconds(565); % in hours
ex_1_run_2_startTime_ms = milliseconds(ex_1_run_2_startTime); % in milliseconds

ex_1_run_2_pos = squeeze(Experiment_1_run_2_0051.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_1_run_2_pos = ex_1_run_2_pos';
ex_1_run_2_rpy = squeeze(Experiment_1_run_2_0051.RigidBodies.RPYs(10,:,:));
ex_1_run_2_rpy = ex_1_run_2_rpy';
ex_1_run_2_timeStamp = [0.01: 0.01: length(ex_1_run_2_pos)/100]' + ex_1_run_2_startTime_ms;

ex_1_run_2_data = [ex_1_run_2_timeStamp ex_1_run_2_pos ex_1_run_2_rpy]; %[TimeStamp,x,y,z,r,p,y]


%% Processing ex_1_run_3 13:50:24.577

ex_1_run_3_startTime = hours(13) + minutes(50) + seconds(24) + milliseconds(577); % in hours
ex_1_run_3_startTime_ms = milliseconds(ex_1_run_3_startTime); % in milliseconds

ex_1_run_3_pos = squeeze(Experiment_1_run_3_0052.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_1_run_3_pos = ex_1_run_3_pos';
ex_1_run_3_rpy = squeeze(Experiment_1_run_3_0052.RigidBodies.RPYs(10,:,:));
ex_1_run_3_rpy = ex_1_run_3_rpy';
ex_1_run_3_timeStamp = [0.01: 0.01: length(ex_1_run_3_pos)/100]' + ex_1_run_3_startTime_ms;

ex_1_run_3_data = [ex_1_run_3_timeStamp ex_1_run_3_pos ex_1_run_3_rpy]; %[TimeStamp,x,y,z,r,p,y]

%% Processing ex_1_run_4 13:56:04.817

ex_1_run_4_startTime = hours(13) + minutes(56) + seconds(04) + milliseconds(817); % in hours
ex_1_run_4_startTime_ms = milliseconds(ex_1_run_4_startTime); % in milliseconds

ex_1_run_4_pos = squeeze(Experiment_1_run_4_0053.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_1_run_4_pos = ex_1_run_4_pos';
ex_1_run_4_rpy = squeeze(Experiment_1_run_4_0053.RigidBodies.RPYs(10,:,:));
ex_1_run_4_rpy = ex_1_run_4_rpy';
ex_1_run_4_timeStamp = [0.01: 0.01: length(ex_1_run_4_pos)/100]' + ex_1_run_4_startTime_ms;

ex_1_run_4_data = [ex_1_run_4_timeStamp ex_1_run_4_pos ex_1_run_4_rpy]; %[TimeStamp,x,y,z,r,p,y]

%% Processing ex_2_run_1 14:05:57.353

ex_2_run_1_startTime = hours(14) + minutes(05) + seconds(57) + milliseconds(353); % in hours
ex_2_run_1_startTime_ms = milliseconds(ex_2_run_1_startTime); % in milliseconds

ex_2_run_1_pos = squeeze(Experiment_2_run_1_0054.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_2_run_1_pos = ex_2_run_1_pos';
ex_2_run_1_rpy = squeeze(Experiment_2_run_1_0054.RigidBodies.RPYs(10,:,:));
ex_2_run_1_rpy = ex_2_run_1_rpy';
ex_2_run_1_timeStamp = [0.01: 0.01: length(ex_2_run_1_pos)/100]' + ex_2_run_1_startTime_ms;

ex_2_run_1_data = [ex_2_run_1_timeStamp ex_2_run_1_pos ex_2_run_1_rpy]; %[TimeStamp,x,y,z,r,p,y]

%% Processing ex_2_run_2 14:13:13.271

ex_2_run_2_startTime = hours(14) + minutes(13) + seconds(13) + milliseconds(271); % in hours
ex_2_run_2_startTime_ms = milliseconds(ex_2_run_2_startTime); % in milliseconds

ex_2_run_2_pos = squeeze(Experiment_2_run_2_0055.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_2_run_2_pos = ex_2_run_2_pos';
ex_2_run_2_rpy = squeeze(Experiment_2_run_2_0055.RigidBodies.RPYs(10,:,:));
ex_2_run_2_rpy = ex_2_run_2_rpy';
ex_2_run_2_timeStamp = [0.01: 0.01: length(ex_2_run_2_pos)/100]' + ex_2_run_2_startTime_ms;

ex_2_run_2_data = [ex_2_run_2_timeStamp ex_2_run_2_pos ex_2_run_2_rpy]; %[TimeStamp,x,y,z,r,p,y]

%% Processing ex_2_run_3 14:21:36.318

ex_2_run_3_startTime = hours(14) + minutes(21) + seconds(36) + milliseconds(318); % in hours
ex_2_run_3_startTime_ms = milliseconds(ex_2_run_3_startTime); % in milliseconds

ex_2_run_3_pos = squeeze(Experiment_2_run_3_0056.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_2_run_3_pos = ex_2_run_3_pos';
ex_2_run_3_rpy = squeeze(Experiment_2_run_3_0056.RigidBodies.RPYs(10,:,:));
ex_2_run_3_rpy = ex_2_run_3_rpy';
ex_2_run_3_timeStamp = [0.01: 0.01: length(ex_2_run_3_pos)/100]' + ex_2_run_3_startTime_ms;

ex_2_run_3_data = [ex_2_run_3_timeStamp ex_2_run_3_pos ex_2_run_3_rpy]; %[TimeStamp,x,y,z,r,p,y]

%% Processing ex_2_run_4 14:28:49.215

ex_2_run_4_startTime = hours(14) + minutes(28) + seconds(49) + milliseconds(215); % in hours
ex_2_run_4_startTime_ms = milliseconds(ex_2_run_4_startTime); % in milliseconds

ex_2_run_4_pos = squeeze(Experiment_2_run_4_0057.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_2_run_4_pos = ex_2_run_4_pos';
ex_2_run_4_rpy = squeeze(Experiment_2_run_4_0057.RigidBodies.RPYs(10,:,:));
ex_2_run_4_rpy = ex_2_run_4_rpy';
ex_2_run_4_timeStamp = [0.01: 0.01: length(ex_2_run_4_pos)/100]' + ex_2_run_4_startTime_ms;

ex_2_run_4_data = [ex_2_run_4_timeStamp ex_2_run_4_pos ex_2_run_4_rpy]; %[TimeStamp,x,y,z,r,p,y]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Processing ex_2_run_5 14:36:20.361

ex_2_run_5_startTime = hours(14) + minutes(36) + seconds(20) + milliseconds(361); % in hours
ex_2_run_5_startTime_ms = milliseconds(ex_2_run_5_startTime); % in milliseconds

ex_2_run_5_pos = squeeze(Experiment_2_run_5_0058.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_2_run_5_pos = ex_2_run_5_pos';
ex_2_run_5_rpy = squeeze(Experiment_2_run_5_0058.RigidBodies.RPYs(10,:,:));
ex_2_run_5_rpy = ex_2_run_5_rpy';
ex_2_run_5_timeStamp = [0.01: 0.01: length(ex_2_run_5_pos)/100]' + ex_2_run_5_startTime_ms;

ex_2_run_5_data = [ex_2_run_5_timeStamp ex_2_run_5_pos ex_2_run_5_rpy]; %[TimeStamp,x,y,z,r,p,y]

%% Processing ex_3_run_1 14:47:29.645

ex_3_run_1_startTime = hours(14) + minutes(47) + seconds(29) + milliseconds(645); % in hours
ex_3_run_1_startTime_ms = milliseconds(ex_3_run_1_startTime); % in milliseconds

ex_3_run_1_pos = squeeze(Experiment_3_run_1_0059.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_3_run_1_pos = ex_3_run_1_pos';
ex_3_run_1_rpy = squeeze(Experiment_3_run_1_0059.RigidBodies.RPYs(10,:,:));
ex_3_run_1_rpy = ex_3_run_1_rpy';
ex_3_run_1_timeStamp = [0.01: 0.01: length(ex_3_run_1_pos)/100]' + ex_3_run_1_startTime_ms;

ex_3_run_1_data = [ex_3_run_1_timeStamp ex_3_run_1_pos ex_3_run_1_rpy]; %[TimeStamp,x,y,z,r,p,y]

%% Processing ex_3_run_2 14:53:59.289

ex_3_run_2_startTime = hours(14) + minutes(53) + seconds(59) + milliseconds(289); % in hours
ex_3_run_2_startTime_ms = milliseconds(ex_3_run_2_startTime); % in milliseconds

ex_3_run_2_pos = squeeze(Experiment_3_run_2_0060.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_3_run_2_pos = ex_3_run_2_pos';
ex_3_run_2_rpy = squeeze(Experiment_3_run_2_0060.RigidBodies.RPYs(10,:,:));
ex_3_run_2_rpy = ex_3_run_2_rpy';
ex_3_run_2_timeStamp = [0.01: 0.01: length(ex_3_run_2_pos)/100]' + ex_3_run_2_startTime_ms;

ex_3_run_2_data = [ex_3_run_2_timeStamp ex_3_run_2_pos ex_3_run_2_rpy]; %[TimeStamp,x,y,z,r,p,y]

%% Processing ex_3_run_3 14:59:42.622

ex_3_run_3_startTime = hours(14) + minutes(59) + seconds(42) + milliseconds(622); % in hours
ex_3_run_3_startTime_ms = milliseconds(ex_3_run_3_startTime); % in milliseconds

ex_3_run_3_pos = squeeze(Experiment_3_run_3_0061.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_3_run_3_pos = ex_3_run_3_pos';
ex_3_run_3_rpy = squeeze(Experiment_3_run_3_0061.RigidBodies.RPYs(10,:,:));
ex_3_run_3_rpy = ex_3_run_3_rpy';
ex_3_run_3_timeStamp = [0.01: 0.01: length(ex_3_run_3_pos)/100]' + ex_3_run_3_startTime_ms;

ex_3_run_3_data = [ex_3_run_3_timeStamp ex_3_run_3_pos ex_3_run_3_rpy]; %[TimeStamp,x,y,z,r,p,y]

%% %% Processing ex_3_run_3 15:05:16.236

ex_3_run_4_startTime = hours(15) + minutes(05) + seconds(16) + milliseconds(236); % in hours
ex_3_run_4_startTime_ms = milliseconds(ex_3_run_4_startTime); % in milliseconds

ex_3_run_4_pos = squeeze(Experiment_3_run_4_0062.RigidBodies.Positions(10,:,:)); % 10 represents Helmet_9 which has the eye-tracker
ex_3_run_4_pos = ex_3_run_4_pos';
ex_3_run_4_rpy = squeeze(Experiment_3_run_4_0062.RigidBodies.RPYs(10,:,:));
ex_3_run_4_rpy = ex_3_run_4_rpy';
ex_3_run_4_timeStamp = [0.01: 0.01: length(ex_3_run_4_pos)/100]' + ex_3_run_4_startTime_ms;

ex_3_run_4_data = [ex_3_run_4_timeStamp ex_3_run_4_pos ex_3_run_4_rpy]; %[TimeStamp,x,y,z,r,p,y]


%% Appending the qualisys data into one set thats pertaining to the Tobii rec011

rec011_Qualisys_data = [ex_1_run_1_data;
    ex_1_run_2_data;
    ex_1_run_3_data;
    ex_1_run_4_data;
    ex_2_run_1_data;
    ex_2_run_2_data;
    ex_2_run_3_data;
    ex_2_run_4_data];

rec012_Qualisys_data = [ex_2_run_5_data;
    ex_3_run_1_data;
    ex_3_run_2_data;
    ex_3_run_3_data;
    ex_3_run_4_data];

% Timestamps of all the individual recordings split between rec011 and rec012
Qualisys_rec011_All_timestamps = rec011_Qualisys_data(:,1); 
Qualisys_rec012_All_timestamps = rec012_Qualisys_data(:,1);


%% Matching the timestamps of Tobii and Qualisys

% Calculating the start time of Tobii ET
Rec011_startTime = hours(13) + minutes(34) + seconds(37) + milliseconds(267); %The actual start time of ET
Rec011_startTime_ms = milliseconds(Rec011_startTime);

Rec012_startTime = hours(14) + minutes(36) + seconds(17) + milliseconds(730); %Tobii recording012 starttime: 14:36:17.730
Rec012_startTime_ms = milliseconds(Rec012_startTime);

THORDatasetRecording011Filtered20190918.Recordingtimestampms = THORDatasetRecording011Filtered20190918.Recordingtimestampms + Rec011_startTime_ms;

THORDatasetRecording012Filtered20190918.Recordingtimestampms = THORDatasetRecording012Filtered20190918.Recordingtimestampms + Rec012_startTime_ms;

Tobii_rec011 = THORDatasetRecording011Filtered20190918.Recordingtimestampms;
Tobii_rec012 = THORDatasetRecording012Filtered20190918.Recordingtimestampms;

Idx_rec011 = knnsearch(Tobii_rec011,Qualisys_rec011_All_timestamps);
Idx_rec012 = knnsearch(Tobii_rec012,Qualisys_rec012_All_timestamps);

Tobii_rec011_matched = Tobii_rec011(Idx_rec011);
Tobii_rec012_matched = Tobii_rec012(Idx_rec012);

Tobii_rec011_array = table2array(THORDatasetRecording011Filtered20190918);
Tobii_rec011_matched_extended_allcol = Tobii_rec011_array(Idx_rec011,:);
Tobii_rec011_matched_extended_allcol(:,1) = []; % removing the Tobii timestamps
REC011_Qualisys_Tobii = [rec011_Qualisys_data Tobii_rec011_matched_extended_allcol];

Tobii_rec012_array = table2array(THORDatasetRecording012Filtered20190918);
Tobii_rec012_matched_extended_allcol = Tobii_rec012_array(Idx_rec012,:);
Tobii_rec012_matched_extended_allcol(:,1) = []; % removing the Tobii timestamps
REC012_Qualisys_Tobii = [rec012_Qualisys_data Tobii_rec012_matched_extended_allcol];

Synchronized_Qualisys_Tobii = [REC011_Qualisys_Tobii;
    REC012_Qualisys_Tobii];

Synchronized_Qualisys_Tobii_table = array2table(Synchronized_Qualisys_Tobii);


header = {'timestamp', 'Pos_X', 'Pos_Y', 'Pos_Z', 'Head_R', 'Head_P', 'Head_Y', 'GazepointX', 'GazepointY', 'Gazepoint3D_X', 'Gazepoint3D_Y', 'Gazepoint3D_Z', 'Gazedirectionleft_X', 'Gazedirectionleft_Y', 'Gazedirectionleft_Z', 'Gazedirectionright_X',	'Gazedirectionright_Y', 'Gazedirectionright_Z',	'Pupilpositionleft_X', 'Pupilpositionleft_Y', 'Pupilpositionleft_Z', 'Pupilpositionright_X', 'Pupilpositionright_Y', 'Pupilpositionright_Z', 'Pupildiameterleft', 'Pupildiameterright', 'Gazeeventduration', 'Eyemovementtype_index', 'Fixationpoint_X', 'Fixationpoint_Y', 'Gyro_X', 'Gyro_Y', 'Gyro_Z', 'Accelerometer_X', 'Accelerometer_Y', 'Accelerometer_Z'};
Synchronized_Qualisys_Tobii_table.Properties.VariableNames = header;
