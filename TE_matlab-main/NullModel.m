% [ ] = NullModel(path_data, path_nullmodel, list_cultures, time_jitter, binsize, n_permutations, maxdelay)
%
% Parameters:
%   path_data          - path to which take the recordings
%   path_nullmodel     - path to which save TE matrices for jittered series
%   list_cultures      - list of culture registration filenames
%   time_jitter        - (opt) jittering time for each spike time of presynaptic neurons
%						 [default 10ms]
%   binsize            - (opt) size of bins to binarize spike times series
%					     size is intended as number of measure time-steps (0.05ms)
%					     [default 20] (20 time-steps=1ms)
%   n_permutations     - (opt) number of null-models to generate per each culture
%						       [default 1000]
%   maxdelay           - (opt) max delay of the pre-synaptic neuron to which calculate TE
%						       [default 1]
%
% Returns:
%   void funtion
%   [ABOUT NULL MODEL:] saves TE matrix for each permutation (for each culture in list_cultures)

%==============================================================================%
% Copyright (c) 2022, University of Padua, Italy							   %
% All rights reserved.														   %
%																			   %
% Authors: Elisa Tentori (elisa.tentori@phd.unipd.it)						   %
%          LiPh Lab - NeuroChip Lab, University of Padua, Italy				   %
%==============================================================================%



function NullModel(path_data,path_nullmodel,list_cultures,time_jitter,binsize,n_permutations,maxdelay)
% Setting Default
if nargin<4
    time_jitter=10;
	n_permutations=1000;
	binsize=20;
	maxdelay=1;
end

if nargin<5
	n_permutations=1000;
	binsize=20;
	maxdelay=1;
end

if nargin<6
	binsize=20;
	maxdelay=1;
end

if nargin<7
	maxdelay=1;
end


list_to_load=path_data+list_cultures+".mat";

for num=1:length(list_cultures)
    
    load(list_to_load(num));
    
    tmax=data.nbins+time_jitter/0.05;
    binarized=zeros(data.nNeurons,ceil(tmax/binsize));

    for neuron_idx=1:length(data.spikes)
        spike_times=data.spikes{neuron_idx};
        spiking_bins = floor(spike_times/binsize);
        binarized(neuron_idx,spiking_bins)=1;
    end

    asdf_post = SparseToASDF(binarized, 1);  %%= turns into cell array
    
    %============================== Null Model ==============================%
    
    for m=1:n_permutations
		m;
        
		M=data.spikes;
		
		%============= Jittero le timeseries originali Norm(step,time_jitter) =============%
		
		for i=1:length(data.spikes)
			for j=1:length(data.spikes{i})
                r=normrnd(data.spikes{i}(j),time_jitter*binsize);
                if r>20
                    M{i}(j) = r;     %== sarebbe 10ms/0.05ms
                else
                    M{i}(j) = 21;
                end
			end
		end
		
		
		%===================== Transfer Entropy delle timeseries jittered =====================%
		
		tmax=data.nbins+time_jitter/0.05;     %== durata di una registrazione+10ms per il delta della jitter
		binarized=zeros(data.nNeurons,ceil(tmax/binsize));
		
		length(M)
		
		%============= binarizzo i dati =============%
		
		for i=1:length(M)
			a=M{i};
			spiking_bins = floor(a/binsize);
			binarized(i,spiking_bins)=1;
		end
		
		
		%============= trasformo binarized in un cell array =============%
		
		asdf_pre = SparseToASDF(binarized, 1);     %== turns into cell array
		
		
		%============= calcolo TE m-esima =============%
		
        display("Calcolo TE")
        if size(asdf_pre)==size(asdf_post)
		   %ASDFTE(timeseries, x_delay(s), x_order, y_order, CI_tau_window);
			if maxdelay==1
				[peakTE] = ASDFTE_perm(asdf_pre, asdf_post, 1,1,1)
			else
				[peakTE, ~, ~] = ASDFTE_perm(asdf_pre, asdf_post, 1:maxdelay,1,1);
			end
				
			filename=path_nullmodel+list_cultures(num)+"_TEPk"+num2str(m)+".txt";
	        dlmwrite(filename,peakTE);
        else
            disp("problem!!");
            disp(size(asdf_pre),' ',size(asdf_pre));
        end
	
	end
		
end
