% Load the spike signal data
load('../Data/combined_active_data.mat');

% Extract spike times for each channel

%factor = 1; % 0.05ms
%factor = 2; % 0.1ms
%factor = 5; % 0.25ms
factor = 10; % 0.5ms
%factor = 20; % 1ms
%factor = 50; % 2.5ms
%factor = 100; % 5ms

spike_signal = false(length(channel_idx), max(frameno)/factor+factor); 

for i = 1:length(channel_idx)
    spike_times = frameno(channel == channel_idx(i));
    spike_times = spike_times / factor;
    spike_signal(i, spike_times) = true;
end

spike_signal = sparse(spike_signal);

%----------------------------------------------------------------------------------------

% Compute coincidences at delay = 0, 1, 2, 5
delays = [0, 1, 2, 5];

% Define the number of channels
num_channels = length(channel_idx);

coincidences = zeros(num_channels, num_channels, length(delays));

% Plots
for i = 1:length(delays)
    delay = delays(i);
    
    % Compute coincidences at the current delay
    for j = 1:num_channels
        
        for k = 1:num_channels
            [j,k]
            coincidences(j, k, i) = sum(spike_signal(j, delay + 1:end) .* spike_signal(k, 1:end - delay));
        end
    end
    
    % Plot histogram for the current delay
    figure;
    histogram(coincidences(:, :, i));
    title(sprintf('Coincidences Histogram (Delay = %d)', delay));
    xlabel('Number of Coincidences');
    ylabel('Frequency');
    
    % Plot heat map for the current delay
    figure;
    imagesc(coincidences(:, :, i));
    colorbar;
    title(sprintf('Coincidences Heatmap (Delay = %d)', delay));
    xlabel('Channel j');
    ylabel('Channel k');
end

saveFilePath = '../Data/coincidences_test.mat';
save(saveFilePath, 'coincidences', '-v7.3');
