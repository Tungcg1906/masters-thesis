% Load the spike signal data
load('../Data/combined_active_data.mat');

% Extract spike times for each channel

spike_signal = false(length(channel_idx),max(frameno)/100+100); 

for i = 1:length(channel_idx)
    spike_times = frameno(channel == channel_idx(i));
    spike_times = spike_times/100;
    spike_signal(i, spike_times) = true; 
end


% Define the Gaussian kernel
sigma_10 = 10; % Standard deviation
sigma_100 = 100;
kernel_size_10 = 5 * sigma_10; % Kernel size 200 frames = 10 ms
kernel_size_100 = 5 * sigma_100; % Kernel size 200 frames = 10 ms 
kernel_10 = exp(-0.5 * (-kernel_size_10:kernel_size_10).^2 / (2 * sigma_10^2));
kernel_100 = exp(-0.5 * (-kernel_size_100:kernel_size_100).^2 / (2 * sigma_100^2));

% Precompute the indices for cropping the convolved signal
crop_start_10 = 5 * sigma_10 + 1;
crop_end_10 = length(spike_signal) - 5 * sigma_10;
crop_start_100 = 5 * sigma_100 + 1;
crop_end_100 = length(spike_signal) - 5 * sigma_100;

% Apply the Gaussian filter to the spike signal for each channel
spike_signal_smooth_10 = zeros(size(spike_signal));
spike_signal_smooth_100 = zeros(size(spike_signal));

for m = 1:length(channel_idx)
    c10 = conv(spike_signal(m, :), kernel_10);
    spike_signal_smooth_10(m, crop_start_10:crop_end_10) = c10(crop_start_10:crop_end_10);

    c100 = conv(spike_signal(m, :), kernel_100);
    spike_signal_smooth_100(m, crop_start_100:crop_end_100) = c100(crop_start_100:crop_end_100);
end

%----------------------------------------------------------------------------------------
% Compute coincidences at delay = 0, 1, 2, 5 
delays = [0,1,2,5]; 

% Define the number of channel
num_channels = length(channel_idx);

coincidences=zeros(num_channels,num_channels,length(delays));


% Plots
for i = 1:length(delays)
    for j = 1:num_channels
        for k = 1:num_channels
            delay = delays(i);
    
            % Compute coincidences at the current delay
            coincidences(j,k,i) = sum(spike_signal(j, delay+1:end) & spike_signal(k, 1:end-delay));

        end
    end
    % Plot histogram for the current delay
    figure;
    histogram(coincidences(:,:,i));
    title(sprintf('Coincidences Histogram (Delay = %d)', delay));
    xlabel('Number of Coincidences');
    ylabel('Frequency');
    
    % Plot heat map for the current delay
    figure;
    imagesc(coincidences(:,:,i));
    colorbar;
    title(sprintf('Coincidences Heatmap (Delay = %d)', delay));
    xlabel('Channel j');
    ylabel('Channel k');
end


%{
interspike_intervals = [];

for i = 1:size(spike_signal, 1)
    spike_times = find(spike_signal(i, :));
    channel_intervals = diff(spike_times);
    interspike_intervals = [interspike_intervals, channel_intervals];

end
figure;
histogram(interspike_intervals);
title('Distribution of interspikeintervals');
xlabel('Interspike interval');
ylabel('Counts');
%}



%---------------------------------------------------------------------------------------------------


%---------------------------------------------------------------------------------------------------
%{
% Functions  

function C=cross_corr(ts,delay)

n=size(ts,1);

C=zeros(n);

for i=1:n
for j=1:n

    size(ts(i,1:end-delay));
    C(i,j)=corr(ts(i,1:end-delay)',ts(j,delay+1:end)');

end
end
end
%}
