% [ ] = rates(path_data,path_results,list_cultures,binsize)
%
% Parameters:
%   path_data        - path to which take the recordings
%   list_cultures    - list of cultures to analyze (name_files without format)
%   path_results     - path to which save results
%   binsize          - (opt) size of bins to binarize spike times series
%					   size is intended as number of measure time-steps (0.05ms)
%					   [default 20] (20 time-steps=1ms)
%
% Returns:
%   void funtion
%   [ABOUT rate:] saves a N array with the rate of each neuron (N=num neurons)
%                 saves a N array with the number of spikes of each neuron

%==============================================================================%
% Copyright (c) 2022, University of Padua, Italy							   %
% All rights reserved.														   %
%																			   %
% Authors: Elisa Tentori (elisa.tentori@phd.unipd.it)						   %
%          LiPh Lab - NeuroChip Lab, University of Padua, Italy				   %
%==============================================================================%


function rates(path_data,path_results,list_cultures,binsize)
% Set defaults
if nargin<4
	binsize=20; %% 1 ms
end

for num=1:length(list_cultures)
    
    load(path_data+list_cultures(num)+".mat");
    
    tmax=data.nbins;    %= Maximum time in which a spike occurred in the recording
    binarized=false(data.nNeurons,ceil(tmax/binsize));

    for i=1:length(data.spikes)
        a=data.spikes{i};
        spiking_bins = floor(a/binsize);
        binarized(i,spiking_bins)=true;
    end

    rate=zeros(1,length(data.spikes));
	number=zeros(1,length(data.spikes));
	
    for i=1:length(data.spikes)
        if(mod(i,100)==0) 
            disp(i)
        end
		rate(i)=sum(binarized(i,:))/length(binarized(i,:));
		number(i)=sum(binarized(i,:));
    end
    
    filename=path_results+list_cultures(num)+"_rate.txt";
    dlmwrite(filename,rate);
    
    filename=path_results+list_cultures(num)+"_rate-NumSpikes.txt";
    dlmwrite(filename,number);
end
