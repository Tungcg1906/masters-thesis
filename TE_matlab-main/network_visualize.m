% Script plot the network of 100 most active channels per each group
% (the links are based on value of distance matrix)
% Return: Network of 100 most active channels

% Load the input struct A
A = load('../Data/combined_active_data.mat');

%-----------------------------------------------------------------------------
% Create graph object for distance
G = graph([], [], 'omitselfloops');
threshold =  6.0e-6;

for i = 1:size(A.distance_mat,1)
    G=addnode(G,1);
end

% Iterate through each pair of channels and add an edge to the graph object
for i = 1:length(A.channel)
    for j = i+1:length(A.channel)
        % Check if i and j are within the bounds of the spikeTimes matrix
        if i <= size(A.distance_mat, 1) && j <= size(A.distance_mat, 2)
            % Add edge with weight equal to distance
            weight = A.distance_mat(i,j);
            if weight > threshold % check weight
                G = addedge(G, i, j, weight);
            end
        end
    end
end

%-----------------------------------------------------------------------------


% Plot graph with edge colors corresponding to edge weights
figure;
p = plot(G, 'XData', A.x, 'YData', A.y);
colormap jet;
colorbar;
title('Channel Network (link based on Distance)');
xlabel('x');
ylabel('y');
p.EdgeCData = G.Edges.Weight;
%saveas(gcf,'network_dis.png')


