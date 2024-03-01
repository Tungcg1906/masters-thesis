% Load the file from a directory
fileDir = '../Null_model_test'; % Specify the directory where the .txt files are located
files = dir(fullfile(fileDir, 'data_spikeTimes_for_TE_TEPk*.txt')); 

for i = 1:numel(files)
    % Read the matrix from the .txt file
    matrix = dlmread(fullfile(fileDir, files(i).name));

    % Perform coincidence calculation
    coincidences = calculateCoincidences(matrix);
    coincidencesData{i} = coincidences;

end

function coincidences = calculateCoincidences(spikeTimes)
    % Input: spikeTimes is a matrix representing spike times, where each row
    % corresponds to a different neuron and each column represents a spike time.
    
    % Compute the number of neurons
    numNeurons = size(spikeTimes, 1);
    
    % Initialize coincidences matrix
    coincidences = zeros(numNeurons);
    
    % Iterate over all pairs of neurons
    for i = 1:numNeurons
        for j = 1:numNeurons
            % Count the number of coincident spikes for each pair of neurons
            coincidences(i, j) = sum((spikeTimes(i, 1:end)& spikeTimes(j, 1:end)));
        end
    end
end


