%% Tract-level ambient PM2.5 baseline computation
% Model baseline pollution in every tract against which marginal emissions
% are evaluated.
%
% CHANGELOG
% - make global user-based variables start with prefix "u_" to help
%   distinguish them (also avoid using protected name 'method,' which is a
%   MATLAB function name)
% - clear IDW_Distribution after selection is made (for memory management)

% Read in input data (40 GB of variable memory before HDF5 implementation)
run Load_Workspace

%% Tract-level SR matrix interpolation
% Applicable for NH3, NOx, & SO2 and PMP & VOCs for point sources
% First, get the chosen interpolation method and specification.
idw = IDW_Distribution{idw_meth, idw_spec};
run Crosswalk_County_to_Tract

%% Clean up step
clear IDW_Distribution

%% end of script
