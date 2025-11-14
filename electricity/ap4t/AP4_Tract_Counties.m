%% County Model Scripts:
%
% CHANGELOG
% - use strcmp rather than '==' for string comparisons
% - add clean up

% Main loop over each user-selected county, f
for f = 1:length(fips)
    fprintf(['FIPS: ' num2str(fips(f),'%05.f') ',']);
    tic
	run AP4_Tract_Setup
    run AP4_Tract_Marginal_Impacts_Ground
    run AP4_Tract_Marginal_Impacts_Non_EGU_Point
    if strcmp(sourced_by_county, 'yes')
        run Sourced_by_County
    endif
    run AP4_Tract_Outputs
    cnty_time = toc;
    printf('%.2f seconds\n', cnty_time)
endfor

%% Clean up
clear MC_Tract_Matrix MD_Tract_Matrix MM_Tract_Matrix Delta_PM_25 Emission_Plus

%% end of script.