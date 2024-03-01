% Plot connection and postion of 2 most active channel based on value of
% rate

% load dataset
data = load('../Data/combined_active_data');

%----------------------------------------------------------------------------

scatter(data.x,data.y,5*data.rates,'MarkerFaceColor','blue')

hold on;

%w = [];

scatter(data.x,data.y,50,'MarkerFaceColor','red')

th = 4.E-5;


hold off;
