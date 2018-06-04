function output = applyExperimentFactors(krishnanSpecification, stage)
%APPLYEXPERIMENTFACTORS - Apply pre-determined adjustment factors for sleep stages
%
% applyExperimentFactors takes a (Krishnan et al., 2016)-type DynaSim model
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

AMPA_to_thal = containers.Map;
AMPA_to_thal('Awake')   = 0.5;
AMPA_to_thal('N2')      = 0.5;
AMPA_to_thal('N3')      = 0.5;
AMPA_to_thal('REM')     = 0.5;

GABA_cortex = containers.Map;
GABA_cortex('Awake')    = 0.22;
GABA_cortex('N2')       = GABA_cortex('Awake')*1.15;
GABA_cortex('N3')       = GABA_cortex('Awake')*1.3;
GABA_cortex('REM')      = GABA_cortex('Awake')*0.7;

GABA_TC = containers.Map;
GABA_TC('Awake')        = 0.55;
GABA_TC('N2')           = GABA_TC('Awake')*1.15;
GABA_TC('N3')           = GABA_TC('Awake')*1.3;
GABA_TC('REM')          = GABA_TC('Awake')*0.7;

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

% TC
KLeak_TC = containers.Map;
KLeak_TC('Awake')       = 0.79;
KLeak_TC('N2')          = KLeak_TC('Awake')*N2_scale;
KLeak_TC('N3')          = KLeak_TC('Awake')*N3_scale;
KLeak_TC('REM')         = KLeak_TC('Awake')*0.9;

shift_H_TC = containers.Map;
shift_H_TC('Awake')     = -8.0;
shift_H_TC('N2')        = -3.0;
shift_H_TC('N3')        = -2.0;
shift_H_TC('REM')       =  0.0;

% NRT
KLeak_NRT = containers.Map;
KLeak_NRT('Awake')      = 0.9;
KLeak_NRT('N2')         = KLeak_NRT('Awake')*((2-N2_scale/2)-0.5);
KLeak_NRT('N3')         = KLeak_NRT('Awake')*((2-N3_scale/2)-0.5);
KLeak_NRT('REM')        = KLeak_NRT('Awake')*1.1;


% ------------------------------------------
%% 2. Combine all the changes to make
% ------------------------------------------

% fac = factor (of adjustment for that experimental stage)

modifications = {...
    % In the original code, this is called: fac_AMPA_D2
    'PYdr<-TC',   'fac_AMPAdepr_PYdr_TC',   AMPA_to_cortex(stage);
    'INdr<-TC',   'fac_AMPAdepr_INdr_TC',   AMPA_to_cortex(stage);
    'PYdr<-PYso', 'fac_AMPAdepr_PYdr_PYso', AMPA_to_cortex(stage);
    'PYdr<-PYso', 'fac_MiniAMPA_PYdr_PYso', AMPA_to_cortex(stage);
    'INdr<-PYso', 'fac_AMPAdepr_INdr_PYso', AMPA_to_cortex(stage);
    'INdr<-PYso', 'fac_MiniAMPA_INdr_PYso', AMPA_to_cortex(stage);
    % In the original code, this is called: fac_AMPA_TC. Also, this was
    %     NEVER actually changed between experimental states!!!
    'NRT<-TC',   'fac_AMPA_NRT_TC',   AMPA_to_thal(stage);
    'NRT<-PYso', 'fac_AMPA_NRT_PYso', AMPA_to_thal(stage);
    'TC<-PYso',  'fac_AMPA_TC_PYso',  AMPA_to_thal(stage);
    % In the original code, this is called: fac_GABA_D2
    'PYdr<-INso', 'fac_GABAAdepr_PYdr_INso', GABA_cortex(stage);
    'PYdr<-INso', 'fac_MiniGABAA_PYdr_INso', GABA_cortex(stage);
    % In the original code, this is called: fac_GABA_TC
    'NRT<-NRT', 'fac_GABAA_NRT_NRT', GABA_TC(stage);
    'TC<-NRT', ' fac_GABAA_TC_NRT',  GABA_TC(stage);
    'TC<-NRT', ' fac_GABAB_TC_NRT',  GABA_TC(stage);
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
    % In the original code, this is called: fac_gkl_TC
    'TC', 'fac_KLeak_TC', KLeak_TC(stage);
    % In the original code, this is called: fac_gh_TC
    'TC', 'fac_shift_H_TC', shift_H_TC(stage);
    % In the original code, this is called: fac_gkl_RE
    'NRT', 'fac_KLeak_NRT', KLeak_NRT(stage); 
};

% ------------------------------------------
%% 3. Apply the changes to the model
% ------------------------------------------
output = dsApplyModifications(krishnanSpecification, modifications);
