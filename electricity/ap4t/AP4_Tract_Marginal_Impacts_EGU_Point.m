%% EGU point source emissions

%% Marginal impacts from EGU point source NH3 emissions
% Recall that Trct_MC_EGU is a 1x5 cell, each cell represents the
% EGU to tract interpolations (e.g., 1859x72538 matrix).
p = 1;
for n = 1:F
    Delta_PM_25 = Trct_MC_EGU{1,p}(n,:)';
    MC_Tract_Matrix(:,n) = Delta_PM_25;

    if ~aqm_only
        run PM_25_Health
        MM_Tract_Matrix(:,n) = Total_Spatial_Deaths;
        MD_Tract_Matrix(:,n) = Total_Spatial_Damage;
    endif
endfor
Results_MC{1,p} = MC_Tract_Matrix;

if ~aqm_only
    Results_MM{1,p} = MM_Tract_Matrix;
    Results_MD{1,p} = MD_Tract_Matrix;
endif

%% Marginal impacts from EGU point source NOx emissions
p = 2;
for n = 1:F
    Delta_PM_25 = Trct_MC_EGU{1,p}(n,:)';
    MC_Tract_Matrix(:,n) = Delta_PM_25;

    if ~aqm_only
        run PM_25_Health
        MM_Tract_Matrix(:,n) = Total_Spatial_Deaths;
        MD_Tract_Matrix(:,n) = Total_Spatial_Damage;
    endif
endfor
Results_MC{1,p} = MC_Tract_Matrix;

if ~aqm_only
    Results_MM{1,p} = MM_Tract_Matrix;
    Results_MD{1,p} = MD_Tract_Matrix;
endif

%% Marginal impacts from EGU point source pri-PM2.5 emissions
p = 3;
for n = 1:F
    Delta_PM_25 = Trct_MC_EGU{1,p}(n,:)';
    MC_Tract_Matrix(:,n) = Delta_PM_25;

    if ~aqm_only
        run PM_25_Health
        MM_Tract_Matrix(:,n) = Total_Spatial_Deaths;
        MD_Tract_Matrix(:,n) = Total_Spatial_Damage;
    endif
endfor
Results_MC{1,p} = MC_Tract_Matrix;

if ~aqm_only
    Results_MM{1,p} = MM_Tract_Matrix;
    Results_MD{1,p} = MD_Tract_Matrix;
endif

%% Marginal impacts from EGU point source SO2 emissions
p = 4;
for n = 1:F
    Delta_PM_25 = Trct_MC_EGU{1,p}(n,:)';
    MC_Tract_Matrix(:,n) = Delta_PM_25;

    if ~aqm_only
        run PM_25_Health
        MM_Tract_Matrix(:,n) = Total_Spatial_Deaths;
        MD_Tract_Matrix(:,n) = Total_Spatial_Damage;
    endif
endfor
Results_MC{1,p} = MC_Tract_Matrix;

if ~aqm_only
    Results_MM{1,p} = MM_Tract_Matrix;
    Results_MD{1,p} = MD_Tract_Matrix;
endif

%% Marginal impacts from EGU point source VOC emissions
p = 5;
for n = 1:F
    Delta_PM_25 = Trct_MC_EGU{1,p}(n,:)';
    MC_Tract_Matrix(:,n) = Delta_PM_25;

    if ~aqm_only
        run PM_25_Health
        MM_Tract_Matrix(:,n) = Total_Spatial_Deaths;
        MD_Tract_Matrix(:,n) = Total_Spatial_Damage;
    endif
endfor
Results_MC{1,p} = MC_Tract_Matrix;

if ~aqm_only
    Results_MM{1,p} = MM_Tract_Matrix;
    Results_MD{1,p} = MD_Tract_Matrix;
endif

%% Clean up step
clear p n

%% end of script.