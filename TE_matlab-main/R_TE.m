% Script plot the graph for TE matrix 
% Return: Plot of Distance matrix (vectorized) against TE(i,j) (vectorized)
% Return: Plot R(i,j) (vectorized) against TE(i,j) (vectorized) and significance test
% Return: Plot R(i,j) (vectorized) against TE delay(i,j) (vectorized)
% Return: Plot histogram of TE values
% Return: Plot heatmap of TE, TE delay and significance test for TE
% Return: Raster spike plot 

% Load the data
data = load('../Data/combined_active_data1.mat');
data_sig = load('../Data/Significant_data1.mat');

%===========================================================================
% Vectorize TE, TE delay and R 

idx = find(eye(100)==0);

TEvec = data.spikeTimes(idx);
TEvec_delay = data.spikeTimes_delay(idx);
dis = data.distance_mat(idx);   
Rvec = (data.rates(:) * data.rates(:)'); 
Rvec = Rvec(idx);
% element-wise multiplication and vectorization
dis = dis(TEvec ~=0);
TEvec_delay = TEvec_delay(TEvec ~= 0); % remove zeros
Rvec = Rvec(TEvec ~= 0); % remove zeros 
TEvec = TEvec(TEvec ~= 0); % remove zeros


%--------------------------------------------------------------------
% Vectorize TE, R, P_values significant 
TEvec_sig = data_sig.spikeTimes(idx);
Rvec_sig = (data_sig.rates(:) * data_sig.rates(:)'); % element-wise multiplication and vectorization
Rvec_sig = Rvec_sig(idx);
Rvec_sig = Rvec_sig(TEvec_sig ~= 0); % remove zeros 
P_values = data_sig.P_values(idx);
P_values = P_values(TEvec_sig ~=0);
dis_sig = data.distance_mat(idx);
dis_sig = dis_sig(TEvec_sig ~=0);
TEvec_sig = TEvec_sig(TEvec_sig ~= 0); % remove zeros


%-----------------------------------------------------------------
% Plot Distance matrix (vectorized) against TE(i,j) (vectorized)
figure;
scatter(dis,log10(TEvec),'filled');
title('Distance matrix vs. Transfer entropy');
xlabel('Distance');
ylabel('Transfer Entropy');
%saveas(gcf,'Dis_TE.png');
saveas(gcf,'Dis_TE1.png');
%-----------------------------------------------------------------
% Plot Distance matrix (vectorized) against TE(i,j) (vectorized)
figure;
scatter(dis_sig,log10(TEvec_sig),'filled');
title('Distance matrix vs. Transfer entropy (sig.)');
xlabel('Distance');
ylabel('Transfer Entropy');
%saveas(gcf,'Dis_TE_sig.png');
saveas(gcf,'Dis_TE_sig1.png');
%------------------------------------------------------------
% Plot R(i,j) (vectorized) against TE(i,j) (vectorized)
figure;
scatter(log10(TEvec), log10(Rvec), 'filled');
title('Transfer Entropy vs. Rates Product');
ylabel('Rates Product');
xlabel('Transfer Entropy');
%saveas(gcf,'R_TE.png');
%saveas(gcf,'R_TE1.png');
%------------------------------------------------------------
% Plot R(i,j) (vectorized) against TE delay(i,j) (vectorized)
figure;
scatter(TEvec_delay, Rvec, 'filled');
title('Delay Transfer Entropy vs. Rates Product');
ylabel('Rates Product');
xlabel('Delay Transfer Entropy');
%saveas(gcf,'R_TE_delay.png')
%saveas(gcf,'R_TE_delay1.png')
%------------------------------------------------------------
% Plot histogram of TE values
figure;
histogram(log10(TEvec), 30);
title('Transfer Entropy Distribution');
xlabel('Transfer Entropy');
ylabel('Frequency');
%saveas(gcf,'his_TE.png')
%saveas(gcf,'his_TE1.png')
%------------------------------------------------------------
% Plot heatmap of TE and TE delay
figure;
imagesc(log10(data.spikeTimes));
title('Transfer Entropy heatmap');
colorbar;
%saveas(gcf,'TE.png')
%saveas(gcf,'TE1.png')
figure;
imagesc(log10(data.spikeTimes_delay));
title('Delay Transfer Entropy heatmap');
colorbar;
%saveas(gcf,'TE_delay.png')
%saveas(gcf,'TE_delay1.png')
%-------------------------------------------------------------
% Plot significant data heat map TE
figure;
imagesc(log10(data_sig.spikeTimes));
title('Transfer Entropy heatmap (significant)');
colorbar;
%saveas(gcf,'TE_sig.png')
%saveas(gcf,'TE_sig1.png')
%------------------------------------------------------------
% Plot R vs TE significant data
figure;
scatter(log10(TEvec_sig), log10(Rvec_sig), 'filled');
title('Transfer Entropy vs. Rates Product (significant)');
ylabel('Rates Product');
xlabel('Transfer Entropy');
%saveas(gcf,'R_TE_sig.png')
%saveas(gcf,'R_TE_sig1.png')
%-------------------------------------------------------
% Plot histogram of TE values (significant)
figure;
histogram(log10(TEvec_sig), 30);
title('Transfer Entropy Distribution (significant)');
xlabel('Transfer Entropy');
ylabel('Frequency');
%saveas(gcf,'his_TE_sig.png')
%saveas(gcf,'his_TE_sig1.png')
%-------------------------------------------------------------
% Plot P value vs TE values (significant)
figure;
scatter(log10(TEvec_sig), log10(P_values), 'filled');
title('Transfer Entropy vs. P values (significant)');
ylabel('P values');
xlabel('Transfer Entropy');
%saveas(gcf,'P_TE_sig.png')
%saveas(gcf,'P_TE_sig1.png')
%----------------------------------------------------------
% Raster plot


%ch = unique(data.channel);

newrates = zeros(100,1);

tmax=max(data.frameno);    %= Maximum time in which a spike occurred in the recording


figure;
hold on;
for i=[53,55]
    spikes = find(data.channel==data.channel_idx(i));
    times = data.frameno(spikes);

    newrates(i) = length(times);
    plot(times,i,'o','MarkerFaceColor','b','MarkerSize',1)
end

xlim([3.5E7,3.6E7])
ylim([52,56])


title('Spike Rasper plot');
hold off; 


figure;
hold on;
for i=[32,33]
    spikes = find(data.channel==data.channel_idx(i));
    times = data.frameno(spikes);

    newrates(i) = length(times);
    plot(times,i,'o','MarkerFaceColor','b','MarkerSize',1)
end

xlim([3.5E7,3.6E7])
ylim([31.5,33.5])


title('Spike Rasper plot');
hold off; 



%

%
%tmax=max(data.frameno)/20;    %= Maximum time in which a spike occurred in the recording

%binarized=false(100,tmax);

%for i=1:100
%    spikes = find(data.channel==ch(i));
%    times = data.frameno(spikes); 
%    times = floor(times/20);

%    binarized(i,times)=true;
%end

%figure;
%hold on;
%for i=1:100
%plot(find(binarized(i,:)),i,'o','MarkerFaceColor','b','MarkerSize',1)
%end


%===================================================================================









