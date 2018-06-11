function output = applyCorticalPaperValues(krishnanSpecification)
%APPLYCORTICALPAPERVALUES - Apply values of model from paper, not code for cortical-only model
%
% applyCorticalPaperValues takes a (Krishnan et al., 2016)-type DynaSim model
% specification and applies the values given in the original paper, which are 
% not necessarily the same values as that seen in the source code. The default 
% values of this overall model (dynasim-krishnan-2016-model) are based on the 
% values seen in the source code, not the paper.
%
% Inputs:
%   'krishnanSpecification': DynaSim specification structure for the (Krishnan
%                            et al., 2016) model
%       - see dsCheckModel and dsCheckSpecification for details
%
% Outputs:
%   'output': DynaSim specification structure for the (Krishnan
%             et al., 2016) model with the paper's values applied
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
%% 1. Combine all the changes to make
% ------------------------------------------

modifications = {...
'PYdr', 'gKLeak', 0.007;
'PYdr', 'gLeak',  0.023;
'PYdr', 'gNaP',   2.0;
'PYdr', 'gNa',    0.8;
'PYdr', 'gHVA',   0.012;
'PYdr', 'gKCa',   0.015;
'PYso', 'gNa',    3000;
'PYso', 'gK',     200;
'PYso', 'gNaP',   15;

'INdr', 'gKLeak', 0.034;
'INdr', 'gLeak',  0.006;
'INdr', 'gNa',    0.8;
'INdr', 'gHVA',   0.012;
'INdr', 'gKCa',   0.015;
'INso', 'gNa',    2500;
'INso', 'gK',     200;

% 0.024 uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.15  mS/cm^2
'PYdr<-PYso', 'gAMPA',     0.15;
% 0.033 uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.2   mS/cm^2
'PYdr<-PYso', 'gMiniAMPA', 0.2;
% 0.001 uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.006 mS/cm^2
'PYdr<-PYso', 'gNMDA',     0.006;

% 0.012 uS * (1 mS / 1000 uS) * (1 / (50*1e-6 cm^2)) = 0.24 mS/cm^2
'INdr<-PYso', 'gAMPA',     0.24;
% 0.02  uS * (1 mS / 1000 uS) * (1 / (50*1e-6 cm^2)) = 0.4  mS/cm^2
'INdr<-PYso', 'gMiniAMPA', 0.4;
% 0.001 uS * (1 mS / 1000 uS) * (1 / (50*1e-6 cm^2)) = 0.02 mS/cm^2
'INdr<-PYso', 'gNMDA',     0.02;

% 0.024 uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.15 mS/cm^2
'PYdr<-INso', 'gGABAA',     0.15;
% 0.02  uS * (1 mS / 1000 uS) * (1 / (165*1e-6 cm^2)) = 0.12 mS/cm^2
'PYdr<-INso', 'gMiniGABAA', 0.12;
};

% ------------------------------------------
%% 2. Apply the changes to the model
% ------------------------------------------
output = dsApplyModifications(krishnanSpecification, modifications);
