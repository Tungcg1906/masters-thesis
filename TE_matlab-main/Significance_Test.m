% [ ] = SignificanceTest(path_data, path_nullmodel, path_results, list_cultures, n_permutations, percent, folder)
%
% Parameters:
%   path_data          - path to which take the TEs calculated
%   path_nullmodel     - path to which are saved TE matrices for jittered series
%   path_results       - path to which to save TEs thresholded
%   list_cultures      - list of culture registration filenames
%   n_permutations     - (opt) number of null-models to generate per each culture
%						 [default 1000]
%   alpha			   - alpha threshold for p-value
%						 [default 0.001]
%   alpha_folder       - folder in path_results in wich to save TE matrices thresholded
%						 [default '1perthous/']
%
% Returns:
%   void funtion
%   [ABOUT TE:] saves TE matrix thresholded based on alpha (for each culture in list_cultures)

%==============================================================================%
% Copyright (c) 2022, University of Padua, Italy							   %
% All rights reserved.														   %
%																			   %
% Authors: Elisa Tentori (elisa.tentori@phd.unipd.it)						   %
%          LiPh Lab - NeuroChip Lab, University of Padua, Italy				   %
%==============================================================================%



function Significance_Test(path_data,path_nullmodel,path_results,list_cultures,n_permutations,alpha)
% Setting Default
if nargin<5
	n_permutations=1000;
	alpha=0.001;
	alpha_folder='1perthous/';
end


for num=1:length(list_cultures)
    
    TE=load(path_data+list_cultures(num)+"_TEPk.txt");
    
    
    %============================== Null Model ==============================%
	
	M_tot=cell(n_permutations);
	
	for m=1:n_permutations
		filename=path_nullmodel+list_cultures(num)+"_TEPk"+num2str(m)+".txt";
		M=load(filename);
		M_tot{m} = M - diag(diag(M));
	end
	
	
	%============================== P Values ==============================%
	
	count=zeros(length(TE),length(TE));
	
	for i=1:length(TE)
		for j=1:length(TE)
			for m=1:n_permutations
				if TE(i,j)<=M_tot{m}(i,j)
					count(i,j)=count(i,j)+1;
				end
			end
		end
	end

	count=count/n_permutations;  %%== p_values matrix for pairs-connections
	
	
	filename=path_results+list_cultures(num)+"_Pvalues.txt";
	dlmwrite(filename,count);
	
	
	%============================== Thresholding 1% ==============================%
	
	TE_1=TE;
	for i=1:length(TE)
		for j=1:length(TE)
			if count(i,j)>alpha
				TE_1(i,j)=0;
			end
		end
	end
	
	filename=path_results+list_cultures(num)+"_TEPk.txt";
	dlmwrite(filename,TE_1);
	
end
