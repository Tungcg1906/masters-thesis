% [ ] = TE_distribution(list_cultures, path_data, path_results)
%
% Parameters:
%   list_cultures   - list of culture registration filenames
%   path_data       - path to recover spike-trains
%   path_results    - path to which save results
%
% Returns:
%   void funtion
%   plots of cumulated TEs (more cultures, more DIVs): cumulative distribution
%   and percentils

%==============================================================================%
% Copyright (c) 2022, University of Padua, Italy							   %
% All rights reserved.														   %
%																			   %
% Authors: Elisa Tentori (elisa.tentori@phd.unipd.it)						   %
%          LiPh Lab - NeuroChip Lab, University of Padua, Italy				   %
%==============================================================================%


function TE_distribution(list_cultures,path_data,path_results)

TE_tot=[]
for num=1:length(list_cultures)
    filename=path_data+list_cultures(num)+"_TEPk.txt";
	TE_mat=load(filename);
    TE_tot=horzcat(TE_tot,reshape(TE_mat.',1,[]));
end


%%==================================================================


h=histogram(TE_tot,100000,'Normalization','probability');
xlabel('TE')
ylabel('persentage')
filename=path_results+"DIVs_tot_Histogram_TE.pdf";
saveas(h,filename);


TE_tot_sorted=sort(TE_tot);

thresholds=zeros(1,100);
for i=1:100
	thresholds(i) = TE_tot_sorted(fix(0.01*i*length(TE_tot)));
end
filename=path_results+"DIVs_tot_thresholds_in_persentage.txt";
dlmwrite(filename,thresholds);

filename=path_results+"DIVs_tot_thresholds_in_persentage.pdf";
fig=plot(thresholds,'.');
xlabel('%')
ylabel('TE')
saveas(fig,filename);


filename=path_results+"DIVs_tot_thresholds_in_persentage_log.pdf";
fig=plot(log10(thresholds),'.');
xlabel('%')
ylabel('log10(TE)')
saveas(fig,filename);
