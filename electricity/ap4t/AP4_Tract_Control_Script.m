% AP4_Tract_Control_Script.m
% written by Luke Dennin, Carnegie Mellon University
% updated for GNU Octave by Tyler W. Davis and Rebecca Rosen, NETL SSC
% modified for Air Quality Modeling only and memory management
% Successfully tested running Octave 7.3.0 on macOS Monterey
% and Octave 9.2.0 on Windows 11.
%
% last edited: 2025-11-14

% Load packages
try
    pkg load hdf5oct
catch
    disp(" ")
    disp("******************************************************")
    disp(" ")
    disp("WARNING: The `hdf5oct` package is not installed.")
    disp("To install, please follow the instructions found here: ")
    disp("https://gnu-octave.github.io/packages/hdf5oct/")
    disp(" ")
    disp("******************************************************")
    disp(" ")
end

%% 0) Globals
% Required NETL EDX API key; downloads all supporting data files.
api_key = "";
% Trigger air quality modeling only when true.
aqm_only = true;
% Set user-defined inverse distance weighting method, of which there are three,
% and the specification, of which there are 2 or 3 options per method.
% 1) Closest Counties: 1) 3 cc, 2) 5 cc, 3) 10 cc
% 2) Counties w/in: 1) cw 30 miles, 2) cw 50 miles, 3) cw 100 miles
% 3) Adjacent Counties: 1) ac to home county, 2) + ac to those in 1
idw_meth = 3;    % update to 3 to match best performer (Dennin et al., 2025)
idw_spec = 2;
% Set user-specified dose-response specification for risk assessment
% 1. ACS = American Cancer Society Cohort: Krewski et al. (2009)
% 2. H6C = Harvard Six Cities Study: Lepeule et al. (2012)
epi_study = 1;
% Set user-specified willingness-to-pay (WTP) analysis year and currency
% inflation year for mortality risk reductions
wtp_year = 2017;    % Year for analysis (options: 2000-2020)
usd_year = 2020;    % Year for USD (options: 2000-2020)
% Set user option whether ground-level source VOC and PMP should be
% aggregated to county level (if no, then leave at the tract level).
sourced_by_county = 'yes'; % "yes" or "no"
% Set user-specified archive option for output files
to_archive = true;

%% 1) Initiate
% This section initiates the tract application of the AP4 model.

% Loads pre-defined workspace with input data and AP4 county-level outputs
% needed for AP4_Tract. Conducts county-to-tract interpolation using
% inverse distance weighting (the specific method can be changed), and
% calculates county-based population totals.
    % Old Run-Time: ~ 4 minutes
tic
run AP4_Tract_Initiation             % 62 GB of memory (before HDF5)
run AP4_Tract_Module_Preparation
prep_time = toc;
printf('Initiation and preparation time: %.2f seconds\n', prep_time)

% Set user-specified county FIPS code (or codes)
% Used to determine the number of source tracts, T (see AP4_Tract_Setup).
% User Input:
%    Single FIPS -- XXXXXXX;
%    Vector of FIPS -- [XXXXXXX YYYYYYY ...];
% RUN ALL COUNTIES
fips = AP4_County_List(:,2)';
% RUN SELECTED COUNTIES
% fips = [42003 42007];

%% 2.A) Evaluate: Counties
% This section runs the tract application of the AP4 model for counties.
% AP4_Tract runs for a specified county (via its FIPS code:
% https://transition.fcc.gov/oet/info/maps/census/fips/fips.txt). It
% evaluates tract-level impacts from marginal emissions released from that
% county (or its tracts for ground-level PMP and VOCs). Output is a folder
% with five files -- one for each pollutant: NH3, NOx, PMP, SO2, & VOCs.
    % Run-Time: Ranges from 20 seconds to 7.5 minutes (for LA County)
    % Most run-time is for file exporting and compression (11.5 GB of files)
    % HDF run (2025-11):
    % - 4.7 min for LA; 2 min for Chicago (Cook)
    % - all county FIPS completed in 38628 s (10.7 h)
run AP4_Tract_Counties

%% 2.B) Evaluate: EGUs
% This section runs the tract application of the AP4 model for EGUs.
% AP4_Tract runs for a specified EGU (via its eis code - see AP4_EGU_List).
% It evaluates tract-level impacts from marginal emissions released from
% that EGU's coordinates. Output is a folder with five files -- one for
% each pollutant: NH3, NOx, PMP, SO2, & VOCs.
% User Inputs (list of EGU IDs and output title)
% - Single eis -- XXXXXXX; Vector [XXXXXXX YYYYYYY ...]
% - NOTE: EGU IDs found in AP4_EGU_List third column

% RUN ALL EGUs
eis = AP4_EGU_List(:, 3)';
u_title = 'All_EGU';
% 2023-02-26 (in-memory method)
% - All EGU execution time: 2642 s (44.0 min)
% 2025-11-14 (HDF optimized method)
% - All EGU execution time:
%   6242.7 s (140.0 min) on win11
%   2243.7 s (37.4 min) on macOS
% Most of the run-time is writing and compressing files (4.42 GB of files)

% RUN SELECT EGUs
% eis = 6789111;
% u_title = 'john_e_amos_plant_in_putnam_wv';
% Run-Time: 10 seconds for single EIS

tic
run AP4_Tract_EGUs
egu_time = toc;
printf("EGU run time: %.2f seconds\n", egu_time)

%% end of script.
