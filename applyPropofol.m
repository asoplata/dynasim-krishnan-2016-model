function output = applyPropofol(krishnanSpecification, decayTimeMultiplier, condMultiplier)
%APPLYPROPOFOL - Apply adjustment factors for applying propofol GABA-Aergic changes
%
% applyPropofol takes a (Krishnan et al., 2016)-type DynaSim model
% specification and applies the adjustment factors for the "propofol" 
% anesthesia state.
%
% Inputs:
%   'krishnanSpecification': DynaSim specification structure for the (Krishnan
%                            et al., 2016) model
%       - see dsCheckModel and dsCheckSpecification for details
%   'decayTimeMultiplier': Amount to multiply GABA-A decay time from propofol
%   'condMultiplier': Amount to multiply GABA-A maximal conductance from propofol
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
%% 1. Combine all the changes to make
% ------------------------------------------

modifications = {...
    'PYdr<-INso', 'propofolTauMult',      decayTimeMultiplier;
    'PYdr<-INso', 'propofolCondMult',     condMultiplier;
    'PYdr<-INso', 'propofolMiniCondMult', condMultiplier;

    'TRN<-TRN', 'propofolTauMult',  decayTimeMultiplier;
    'TRN<-TRN', 'propofolCondMult', condMultiplier;

    'TC<-TRN', 'propofolTauMult',   decayTimeMultiplier;
    'TC<-TRN', 'propofolCondMult',  condMultiplier;
};

% ------------------------------------------
%% 3. Apply the changes to the model
% ------------------------------------------
output = dsApplyModifications(krishnanSpecification, modifications);
