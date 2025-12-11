%% Marginal Ground-Level Impacts
%
% CHANGELOG
% - liberally add air quality modeling if-statements

%% Ground level emissions
b = 1;

%% Marginal impacts from ground level NH3 emissions
p = 1;
Delta_PM_25 = Trct_MC{b,p}';
Results_MC{b,p} = Delta_PM_25;

if ~aqm_only
    run PM_25_Health
    Results_MM{b,p} = Total_Spatial_Deaths;
    Results_MD{b,p} = Total_Spatial_Damage;
endif

%% Marginal impacts from ground level NOx emissions
p = 2;
Delta_PM_25 = Trct_MC{b,p}';
Results_MC{b,p} = Delta_PM_25;

if ~aqm_only
    run PM_25_Health
    Results_MM{b,p} = Total_Spatial_Deaths;
    Results_MD{b,p} = Total_Spatial_Damage;
endif

%% Marginal impacts from ground level pri-PM2.5 emissions
p = 3;
for n = 1:T
    %fprintf('Ground-level PMP: %3.3f\r', 100*n/T);
    Emission_Plus = zeros(T,1);
    Emission_Plus(n,1) = Emission_Plus(n,1) + 1;
    Delta_PM_25 = (Emission_Plus'*Trct_MC{b,p})';
    MC_Tract_Matrix(:,n) = Delta_PM_25;

    if ~aqm_only
        run PM_25_Health
        MM_Tract_Matrix(:,n) = Total_Spatial_Deaths;
        MD_Tract_Matrix(:,n) = Total_Spatial_Damage;
    endif
endfor
%fprintf('Ground-level PMP: %3.3f\n', 100*n/T);

Results_MC{b,p} = MC_Tract_Matrix;

if ~aqm_only
    Results_MM{b,p} = MM_Tract_Matrix;
    Results_MD{b,p} = MD_Tract_Matrix;
endif

%% Marginal impacts from ground level SO2 emissions
p = 4;
Delta_PM_25 = Trct_MC{b,p}';
Results_MC{b,p} = Delta_PM_25;

if ~aqm_only
    run PM_25_Health
    Results_MM{b,p} = Total_Spatial_Deaths;
    Results_MD{b,p} = Total_Spatial_Damage;
endif

%% Marginal impacts from ground level VOC emissions
p = 5;
for n = 1:T
    %fprintf('Ground-level VOC: %3.3f\r', 100*n/T);
    Emission_Plus = zeros(T,1);
    Emission_Plus(n,1) = Emission_Plus(n,1) + 1;
    Delta_PM_25 = (Emission_Plus'*Trct_MC{b,p})';
    MC_Tract_Matrix(:,n) = Delta_PM_25;

    if ~aqm_only
        run PM_25_Health
        MM_Tract_Matrix(:,n) = Total_Spatial_Deaths;
        MD_Tract_Matrix(:,n) = Total_Spatial_Damage;
    endif
endfor
%fprintf('Ground-level VOC: %3.3f\n', 100*n/T);

Results_MC{b,p} = MC_Tract_Matrix;

if ~aqm_only
    Results_MM{b,p} = MM_Tract_Matrix;
    Results_MD{b,p} = MD_Tract_Matrix;
endif

%% Clean up
clear p n b

%% end of script.