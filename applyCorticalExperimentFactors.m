function output = applyCorticalExperimentFactors(krishnanSpecification, stage)
%APPLYCORTICALEXPERIMENTFACTORS - Apply pre-determined adjustment factors for sleep stages for cortical-only model
%
% applyCorticalExperimentFactors takes a (Krishnan et al., 2016)-type DynaSim model
% specification and applies the adjustment factors for one of the four
% different behavioral states investigated in the original paper: Awake, NREM2,
% NREM3, and REM.
%
% Inputs:
%   'krishnanSpecification': DynaSim specification structure for the (Krishnan
%                            et al., 2016) model
%       - see dsCheckModel and dsCheckSpecification for details
%   'stage': which sleep stage to adjust the model to, choose from {'Awake',
%       'N2', 'N3', 'REM'} (default: 'Awake')
%
% Outputs:
%   'output': DynaSim specification structure for the (Krishnan
%             et al., 2016) model with the adjustment factors applied
%
% Dependencies:
%   - This has only been tested on MATLAB version 2017a.
%
% References:
%   - Krishnan GP, Chauvette S, Shamie I, Soltani S, Timofeev I, Cash SS, et
%     al. Cellular and neurochemical basis of sleep stages in the
%     thalamocortical network. eLife. 2016;5: e18607.
%
% Author: Austin E. Soplata <austin.soplata@gmail.com>
% Copyright (C) 2018 Austin E. Soplata, Boston University, USA

% ------------------------------------------
%% 1. Calculate all scaling factors
% ------------------------------------------
% General scaling
N2_scale = 1.2;
N3_scale = 1.8;

% Synaptic
AMPA_to_cortex = containers.Map;
AMPA_to_cortex('Awake') = 0.2;
AMPA_to_cortex('N2')    = AMPA_to_cortex('Awake')*N2_scale*1.0;
AMPA_to_cortex('N3')    = AMPA_to_cortex('Awake')*N3_scale*1.1;
AMPA_to_cortex('REM')   = AMPA_to_cortex('Awake')*0.85;

GABA_cortex = containers.Map;
GABA_cortex('Awake')    = 0.22;
GABA_cortex('N2')       = GABA_cortex('Awake')*1.15;
GABA_cortex('N3')       = GABA_cortex('Awake')*1.3;
GABA_cortex('REM')      = GABA_cortex('Awake')*0.7;

% Intrinsic
% Cortex
K_cortex = containers.Map;
K_cortex('Awake')       = 1.0;
K_cortex('N2')          = 1.0;
K_cortex('N3')          = 1.0;
K_cortex('REM')         = 1.0;

KCaM_cortex = containers.Map;
KCaM_cortex('Awake')    = 1.0;
KCaM_cortex('N2')       = 1.0;
KCaM_cortex('N3')       = 1.0;
KCaM_cortex('REM')      = 1.0;

KLeak_cortex = containers.Map;
KLeak_cortex('Awake')   = 0.19;
KLeak_cortex('N2')      = KLeak_cortex('Awake')*N2_scale;
KLeak_cortex('N3')      = KLeak_cortex('Awake')*N3_scale;
KLeak_cortex('REM')     = KLeak_cortex('Awake')*0.9;

% ------------------------------------------
%% 2. Combine all the changes to make
% ------------------------------------------

% fac = factor (of adjustment for that experimental stage)

modifications = {...
    % In the original code, this is called: fac_AMPA_D2
    'PYdr<-PYso', 'fac_AMPAdepr_PYdr_PYso', AMPA_to_cortex(stage);
    'PYdr<-PYso', 'fac_MiniAMPA_PYdr_PYso', AMPA_to_cortex(stage);
    'INdr<-PYso', 'fac_AMPAdepr_INdr_PYso', AMPA_to_cortex(stage);
    'INdr<-PYso', 'fac_MiniAMPA_INdr_PYso', AMPA_to_cortex(stage);
    % In the original code, this is called: fac_GABA_D2
    'PYdr<-INso', 'fac_GABAAdepr_PYdr_INso', GABA_cortex(stage);
    'PYdr<-INso', 'fac_MiniGABAA_PYdr_INso', GABA_cortex(stage);
    % In the original code, this is called: fac_gkl
    'PYdr', 'fac_KLeak_PYdr', KLeak_cortex(stage);
    'INdr', 'fac_KLeak_INdr', KLeak_cortex(stage);
    % In the original code, this is called: fac_gkca_cx, but it is never used!
    'PYdr', 'fac_KCa_PYdr', KCaM_cortex(stage);
    'INdr', 'fac_KCa_INdr', KCaM_cortex(stage);
    % In the original code, this is called: fac_gkm_cx. Also, this was never
    %     actually changed between experimental states!!!
    'PYdr', 'fac_M_PYdr', KCaM_cortex(stage);
    'INdr', 'fac_M_INdr', KCaM_cortex(stage);
    % In the original code, this is called: fac_gkv_cx. Also, this was never
    %     actually changed between experimental states!!!
    'PYso', 'fac_K_PYso', K_cortex(stage);
    'INso', 'fac_K_INso', K_cortex(stage);
};

% ------------------------------------------
%% 3. Apply the changes to the model
% ------------------------------------------
output = dsApplyModifications(krishnanSpecification, modifications);
