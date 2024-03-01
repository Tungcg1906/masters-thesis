function NullModel_test(path_data, path_nullmodel, list_cultures, binsize, n_permutations, maxdelay)
    % Setting Default
    if nargin < 4
        binsize = 20;
        n_permutations = 1000;
        maxdelay = 0;
    end

    if nargin < 5
        n_permutations = 1000;
        maxdelay = 0;
    end

    if nargin < 6
        maxdelay = 0;
    end

    list_to_load = path_data + list_cultures + ".mat";

    for num = 1:length(list_cultures)

        %n_permutations=5;
        
        load(list_to_load(num));

        tmax = data.nbins;
        binarized=false(data.nNeurons, ceil(tmax/binsize));

        numNeurons=length(data.spikes);

        for neuron_idx = 1:numNeurons
            spike_times = data.spikes{neuron_idx} + maxdelay; % apply the delay (default delay = 0)
            spiking_bins = floor(spike_times / binsize);
            binarized(neuron_idx, spiking_bins) = true;
        end
        
        binarized = sparse(binarized);
  
        coincidences = zeros(numNeurons); % Initialize coincidences matrix

        for i = 1:numNeurons
            coincidences(i, :) = binarized*binarized(i, :)';
        end

        Pvalues = ones(numNeurons);


        %============================== Null Model ==============================%

        for m = 1:n_permutations-1

            disp(['permute',num2str(m)]);
            %============= Generate unique random circular shift delays for all spike times =============%

            num_shifts = numNeurons; % Number of shifts to generate (assumes all rows have the same number of spike times)
            shifts = randi([tmax/2,tmax], 1, num_shifts); % Generate random shifts between 0 and binsize-1
        
            

            M = data.spikes;
            for i = 1:length(data.spikes)
                M{i} = mod(int32(data.spikes{i}) + int32(shifts(i)) + maxdelay, int32(tmax)); % Apply circular shift + delay
            end


            %===================== Transfer Entropy of the shifted timeseries =====================%

            tmax = data.nbins; % duration of a recording
            binarized_shifted = false(data.nNeurons, ceil(tmax / binsize));

            %============= Binarize the shifted data =============%
            for i = 1:numNeurons
                a = M{i};
                spiking_bins = floor(a / binsize);
                binarized_shifted(i, spiking_bins) = true;
            end

            binarized_shifted=sparse(binarized_shifted);
    
  
            %===================== Calculate coincidences =====================%
            disp('Calculate Coincidences');


            % Iterate over all pairs of neurons
            coincidences_perm = zeros(numNeurons); % Initialize coincidences matrix

            for i = 1:numNeurons
                %i
                coincidences_perm(i, :) = binarized_shifted*binarized_shifted(i, :)';
            end

            Pvalues=Pvalues+(coincidences_perm>=coincidences);
        end

        Pvalues=Pvalues/n_permutations;
        permutation_filename = path_nullmodel + list_cultures(num) + "_Permutation_Pvalues_" + num2str(m) + "Delay" + num2str(maxdelay) + ".txt";
        dlmwrite(permutation_filename, Pvalues);
            
    end


end
