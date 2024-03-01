% [ ] = TE_r(path_data, path_significativity, path_results, list_cultures, alpha_folder)
%
% Parameters:
%   path_data          	 	 - path to which take the list of possible distances in the MEA
%   path_significativity     - path to which are saved TE matrices after significance test
%   path_results       		 - path to which save TE(r) and r distribution
%   list_cultures      		 - list of culture registration filenames
%   alpha_folder       		 - folder in path_results in wich to save TE matrices thresholded
%						 	   [default '1perthous/']
%
% Returns:
%   void funtion
%   [ABOUT TE:] saves cell array with significant TEs classified as function of
%			    neuron-pairs distances
%	[ABOUT DISTANCES:] saves an array with the distribution of distances referred
%					   to neuron-pairs with significant connection

%==============================================================================%
% Copyright (c) 2022, University of Padua, Italy							   %
% All rights reserved.														   %
%																			   %
% Authors: Elisa Tentori (elisa.tentori@phd.unipd.it)						   %
%          LiPh Lab - NeuroChip Lab, University of Padua, Italy				   %
%==============================================================================%


function TE_r(path_data,path_significativity,path_results,list_cultures,alpha_folder)
% Setting Default
if nargin<5
	alpha_folder="1perthous/";
end

r=load(path_data+"r_8x8.txt");

TE_1_r_tot=[];
r_tot=[];

for num=1:length(list_cultures)

        TE_r=cell(length(r));
        list_r=cell(length(r));

        %======= Loading Thresholded TE ======%

        filename=path_significativity+alpha_folder+list_cultures(num)+"_TEPk.txt";
        TE_1=load(filename);

        %======= Loading distance matrix ======%

        filename=path_results+list_cultures(num)+"_DistanceMat.txt";
        mat_d=load(filename);

        %======= TE based on DISTANCE ======%

        for i_r=1:length(r)
                for i=1:length(mat_d)
                        for j=1:length(mat_d)
                                if (mat_d(i,j)==r(i_r)) && (i~=j) && (TE_1(i,j)~=0)
                                        TE_r{i_r} = horzcat(TE_r{i_r},TE_1(i,j));
                                        list_r{i_r} = horzcat(list_r{i_r},r(i_r));
                                end
                        end
                end
        end

        list_r_=[];
		TE=[];
        for i_r=1:length(r)
                list_r_=horzcat(list_r_,list_r{i_r});
                TE=horzcat(TE,TE_r{i_r});
        end

        filename=path_significativity+alpha_folder+list_cultures(num)+"_TEP_r.txt";
        dlmwrite(filename,TE);

        filename=path_significativity+alpha_folder+list_cultures(num)+"_r.txt";
        dlmwrite(filename,list_r_);


        TE_1_r_tot=horzcat(TE_1_r_tot,TE);
        r_tot=horzcat(r_tot,list_r_);

end

filename=path_significativity+alpha_folder+"totCult_TEP_r.txt";
dlmwrite(filename,TE_1_r_tot);

filename=path_significativity+alpha_folder+"totCult_r.txt";
dlmwrite(filename,r_tot);
