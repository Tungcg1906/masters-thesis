% Script matching the data structure and identify the most active channel
% Saved data: combined_data.mat (combined data for matching structure)
% Saved data: active_channel_only_data.mat (reduced data for most active channel based on rate for each group)
% Saved data: combined_active_data.mat (reduced data with TE and TE delay matrix)
% Saved data: Significant_data.mat (reduced data with TE significance matrix)
% Return: Plot of all groups channel
% Return: Plot of most active channel per group
% Return: Plot of coefficient of variaion for each channel


% Load the data
A = load('../Data/channels.mat');
B = load('../Data/data_spikeTimes.mat');



if ~exist('Plots', 'dir')
    mkdir('Plots');
end
%------------------------------------------------------------------------------
channel1 = zeros(length(B.channel),1);

data0 = struct();

% Finding the frames
for i=1:length(A.channel)
    m=A.channel(i);
    v=find(B.channel==m);
    channel1(v)=i;
end

good_frames = find(channel1);
%good_frames = sort(good_frames);

channel1=channel1(good_frames);

% Use the indices to select only the relevant channels from the spikes struct
frameno = B.frameno; 
amplitude = B.amplitude;

frameno=frameno(good_frames);
amplitude=amplitude(good_frames);

electrode = A.electrode;
x = A.x;
y = A.y;
channel = channel1; 

data0.frameno = frameno; 
data0.channel = channel; 
data0.amplitude = amplitude;
data0.electrode = A.electrode;
data0.x = A.x;
data0.y = A.y;


Num_channels = length(x);

% Calculating the rates
tmax = max(frameno);
tmin = min(frameno);
duration = (tmax - tmin);

rates = zeros(Num_channels,1);


for i=1:Num_channels
    sp = find(channel==i);
    rates(i) = double(length(sp))/double(duration);
end

data0.rates = rates;

%-----------------------------------------------------------------------------------------------------------------

% Label channels in groups
Dx = zeros(Num_channels);
Dy = zeros(Num_channels);

for i=1:Num_channels
    for j=1:Num_channels
        Dx(i,j)=x(i)-x(j);
        Dy(i,j)=y(i)-y(j);
    end
end

sDx = sort(unique(abs(Dx(:))));
minDx = sDx(2);
sDy = sort(unique(abs(Dy(:))));
minDy = sDy(2);

Dx=Dx/minDx;
Dy=Dy/minDy;


G = graph();

for i=1:Num_channels
    for j=i+1:Num_channels
        if(max(abs(Dx(i,j)), abs(Dy(i,j)))==1)
           G = addedge(G,i,j);  
        end
    end
end

group_labels = conncomp(G);
data0.group_labels = group_labels;

figure;
gscatter(x,y, group_labels);
xlabel('X-coordinate');
ylabel('Y-coordinate');
title('Groups channel');
lgd = legend('Location', 'northeast');
lgd.Position(1) = lgd.Position(1) + 0.1;  % Increase the x-position
lgd.Position(2) = lgd.Position(2) + 0.1;  % Increase the y-position
saveas(gcf,'Plots/Group_channel.png');
%saveas(gcf,'Group_channel1.png');
%saveas(gcf,'Group_channel2.png');
%----------------------------------------------------------------------------------------------

%Find the most active channel in a group base on rates
%Find number of groups
unique_groups = unique(group_labels);
num_groups = length(unique_groups); 

%Assign rates to each group channel
group_rates = zeros(length(A.channel), num_groups);

%Find max rate for each group
group_max_rates = zeros(num_groups,1);
figure;
for m=1:num_groups
    group_idx = find(group_labels == unique_groups(m));

    scatter(x(group_idx),y(group_idx),'filled','k')

    %Find the max rate and its index
    [group_max_rates(m), max_idx] = max(rates(group_idx));
    group_max_rates(m) = A.channel(group_idx(max_idx));

    %Find the inidices of max channel
    idx = find(A.channel==group_max_rates(m));  %unique_groups(m));

    %Plot

    scatter(x(idx),y(idx),'filled')
    hold on;
end

fprintf('Most active channel based on rates :%d \n',channel(group_idx(max_idx)));

colorbar;
xlabel('X-coordinate');
ylabel('Y-coordinate');
title('Most activated channels based on rates');
saveas(gcf,'Plots/Active_channel.png');


%-----------------------------------------------------------------------------------------------
%Calculate the coefficient of variaion for each channel
% Calculate coefficient of variation for each group
unique_labels = unique(group_labels);
cv_rates = zeros(size(unique_labels));
for i = 1:length(unique_labels)
    group_rates = rates(group_labels == unique_labels(i));
    cv_rates(i) = std(group_rates) / mean(group_rates);
end

%Display the results
%for i = 1:length(unique_labels)
%    fprintf('CV for group %d: %.2f\n', unique_labels(i), cv_rates(i));
%end


% Plot bar chart of CV for each group
%figure;
%bar(unique_labels, cv_rates);
%xlabel('Group');
%ylabel('Coefficient of Variation');
%title('Coefficient of variation for Each Group');


%====================================================================================================

% Reduce data to fine most active channel for each group 

% Load the combined data file
%data = load('../Data/combined_data.mat');   

% Find the unique group labels
unique_groups = unique(data0.group_labels);

% Create a new structure to store the data for the most active channel in each group
active_data = struct();

amplitude1=[];
channel1=[];
frameno1=[];

% Loop over the groups
for i = 1:length(unique_groups)
    
    % Find the indices of the channels in this group
    group_idx = find(data0.group_labels == unique_groups(i));
    
    % Find the index of the most active channel in this group
    [~, max_idx] = max(data0.rates(group_idx));
    max_channel_idx = group_idx(max_idx);
   
    
    v=find(data0.channel==max_channel_idx);
    amplitude1=[amplitude1;data0.amplitude(v)];
    channel1=[channel1;data0.channel(v)];
    frameno1=[frameno1;data0.frameno(v)];
    


    % Copy the data for the most active channel to the new structure
    active_data.channel_idx(i) = max_channel_idx;
    active_data.electrode(i) = data0.electrode(max_channel_idx);
    active_data.group_labels(i) = data0.group_labels(max_channel_idx);
    active_data.rates(i) = data0.rates(max_channel_idx);
    active_data.x(i) = data0.x(max_channel_idx);
    active_data.y(i) = data0.y(max_channel_idx);
end

active_data.amplitude =amplitude1;  %data.amplitude(max_channel_idx);
active_data.channel = channel1;  %data.channel(max_channel_idx);
active_data.frameno = frameno1;  % data.frameno(max_channel_idx);
    
% Save the active data to a new file
save('../Data/active_channel_only_data.mat', '-struct', 'active_data');

                                                                                                                                                                                                                       
%=========================================================================================

% Compute the TE for most active data

%OurData =  load('../Data/active_channel_only_data.mat');

data = struct();

all_channels = unique(active_data.channel);
NumChannels = length(all_channels);

spikes = {};

for n=1:NumChannels

    m = active_data.channel_idx(n); %all_channels(n);
    %m = MinIndex+n-1;
    channelSpikes = find(active_data.channel==m);

    spikes{n} = double(active_data.frameno(channelSpikes));
end

Nbins = max(max(active_data.frameno));

data.spikes = spikes';

data.nNeurons = NumChannels;

data.nbins = Nbins;

data.binsize = 0.05;

data.channel = (1:NumChannels);

data.channel = data.channel';

data.channel_idx = active_data.channel_idx;


save('../Data/data_spikeTimes_for_TE.mat', 'data'); 
Calculate_TE('../Data/',"data_spikeTimes_for_TE",'../Results/',10,20);

SSSSSSSSSSSSSSSS
%NullModel('../Data/','../Null_model/',"data_spikeTimes_for_TE");
%Significance_Test('../Results/','../Null_model/','../Data',"data_spikeTimes_for_TE",1000,0.05);


%-------------------------------------------------------------------------

% Save the data with most active channel with results of TE 

% Load the data from the .mat file
%load('../Data/active_channel_only_data.mat');

data1 = struct();

% Load the spike time data from the .txt file
spikeTimes = dlmread('../Results/data_spikeTimes_for_TE_TEPk.txt');
spikeTimes_delay = dlmread('../Results/data_spikeTimes_for_TE_TEdelays.txt');
distance_mat = dlmread('../Results/data_spikeTimes_for_TE_DistanceMat.txt');

% Create a new field in the data struct to hold the spike times
data1.spikeTimes = spikeTimes;
data1.spikeTimes_delay = spikeTimes_delay;
data1.distance_mat = distance_mat;

% Add additional fields to the data struct, as needed
data1.amplitude = active_data.amplitude;
data1.channel = active_data.channel;
data1.electrode = active_data.electrode;
data1.frameno = active_data.frameno;
data1.group_labels = active_data.group_labels;
data1.rates = active_data.rates;
data1.x = active_data.x;
data1.y = active_data.y;

data1.channel_idx = active_data.channel_idx;

% Save the combined data to a new .mat file



%save('../Data/combined_active_data1.mat', '-struct', 'data1');
%save('../Data/combined_active_data2.mat', '-struct', 'data1');
%----------------------------------------------------------------------------

% Save the result for significance test 

% Load the data from the .txt file
spikeTimes = dlmread('../Data/data_spikeTimes_for_TE_TEPk.txt');
P_values = dlmread('../Data/data_spikeTimes_for_TE_Pvalues.txt');

data2 = struct();
% Create a new field in the data struct to hold the spike times
data2.spikeTimes = spikeTimes;
data2.P_values = P_values;

% Add additional fields to the data struct, as needed
data2.amplitude = active_data.amplitude;
data2.channel = active_data.channel;
data2.electrode = active_data.electrode;
data2.frameno = active_data.frameno;
data2.group_labels = active_data.group_labels;
data2.rates = active_data.rates;
data2.x = active_data.x;
data2.y = active_data.y;

% Do some data processing or analysis here, if needed

% Save the combined data to a new .mat file
save('../Data/Significant_data.mat', '-struct', 'data2');
%save('../Data/Significant_data1.mat', 'frameno', 'channel', 'amplitude', 'electrode', 'x', 'y', 'group_labels','spikeTimes','P_values','rates');
%save('../Data/Significant_data2.mat', 'frameno', 'channel', 'amplitude', 'electrode', 'x', 'y', 'group_labels','spikeTimes','P_values','rates');

















