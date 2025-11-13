%% Generate population matrices
% 72,538 tracts and 19 age groups
%
% CHANGELOG
% - move One and One_Mat up a level to AP4_Tract_Module_Preparation
% - add air quality model only if-statement
% - add clean up for iterator, r

% Needed for AQM and Sourced_by_County
Pop_Matrix = Population_Data{1,1};
Pop_Total = zeros(R,1);
for r = 1:R
    Pop_Total(r,1) = sum(Pop_Matrix(r,:));
endfor

if ~aqm_only
    MR_Matrix = MR_Data{1,1};

    Pop_Total_Infants = zeros (R,1);
    Pop_Total_Youth = zeros (R,1);
    Pop_Total_Adults = zeros (R,1);
    Pop_Total_Seniors = zeros (R,1);

    Pop_Under1 = Pop_Matrix;
    Pop_Over25 = Pop_Matrix;
    Pop_Over30 = Pop_Matrix;
    Pop_Over65 = Pop_Matrix;

    %% Check totals
    for r = 1:R
        Pop_Total_Infants(r,1) = sum(Pop_Matrix(r,1));
    endfor

    for r = 1:R
        Pop_Total_Youth(r,1) = sum(Pop_Matrix(r,2:7));
    endfor

    for r = 1:R
        Pop_Total_Adults(r,1) = sum(Pop_Matrix(r,8:14));
    endfor

    for r = 1:R
        Pop_Total_Seniors(r,1) = sum(Pop_Matrix(r,15:19));
    endfor

    %% Population matrix creation
    for r = 2:19
        Pop_Under1(:,r) = zeros(R,1);
    endfor

    for r = 1:6
        Pop_Over25(:,r) = zeros(R,1);
    endfor

    for r = 1:7
        Pop_Over30(:,r) = zeros(R,1);
    endfor

    for r = 1:14
        Pop_Over65(:,r) = zeros(R,1);
    endfor
endif

%% Clean up
clear r

%% end of script.