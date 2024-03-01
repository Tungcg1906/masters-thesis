%path_to_load = "../izhikevich_network-main/izhikevich_simulator/result_1Data";


% loading neurons positions
%   x=pos(:,1)
%   y=pos(:,2)
pos = load('../izhikevich_network-main/izhikevich_simulator/result_1/Data/net_n_positions.txt');


% loading the array (channel, frameno)
%   elec=sp(:,1)
%   frameno=sp(:,2)
sp = load("../izhikevich_network-main/izhikevich_simulator/result_1/Data/spikeTimes.txt");
sp(:,1) = sp(:,1)+1;


nNeurons = length(unique(sp(:,1)));


spikes = {};
for i=1:nNeurons
    spikes{i} = sp(sp(:,1)==i,2)';
end
spikes = spikes';


data = struct;
data.spikes = spikes;
data.nNeurons = nNeurons;
data.binsize = 0.0500;
data.nbins = 12000000; %600sec*1000msec*0.05
data.recordingID = 'SyntCult_NoPlasticity_1';
data.datatype = 'Spikes';
data.expsys = 'Synthetic Dissociated Cultures';
data.channel = unique(sp(:,1));
data.pos = pos;


save('../Data/SyntCult_NoPlasticity_1.mat', '-struct','data');
