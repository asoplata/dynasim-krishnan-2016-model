function output = removeCorticalNoiseIC(krishnanSpecification)
%REMOVECORTICALNOISEIC - Set all initial condition noise to 0 for cortex portion of (Krishnan et al., 2016) models
%
% For a (Krishnan et al., 2016)-style DynaSim specification, this function
% simply sets all the initial condition noise terms to 0, so that every
% simulation using this has the same starting conditions. This is useful for
% both reproducibility and debugging.
%
% Inputs:
%   'krishnanSpecification': DynaSim specification structure for the (Krishnan
%                            et al., 2016) model
%     - see dsCheckModel and dsCheckSpecification for details
%
% Outputs:
%   'output': DynaSim specification structure for the (Krishnan
%             et al., 2016) model with all initial condition noise removed.
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
%% 1. Set all NoiseIC terms to 0
% ------------------------------------------
modifications  = {...
  'INdr',        'CaBufferNoiseIC'     ,     0;
  'PYdr',        'CaBufferNoiseIC'     ,     0;
  'INdr<-PYso',  'sAMPANoiseIC'        ,     0;
  'INdr<-PYso',  'deprAMPANoiseIC'     ,     0;
  'PYdr<-PYso',  'sAMPANoiseIC'        ,     0;
  'PYdr<-PYso',  'deprAMPANoiseIC'     ,     0;
  'PYdr<-INso',  'sGABAANoiseIC'       ,     0;
  'PYdr<-INso',  'deprGABAANoiseIC'    ,     0;
  'INdr',        'mHVANoiseIC'         ,     0;
  'INdr',        'hHVANoiseIC'         ,     0;
  'PYdr',        'mHVANoiseIC'         ,     0;
  'PYdr',        'hHVANoiseIC'         ,     0;
  'INdr',        'mKCaNoiseIC'         ,     0;
  'PYdr',        'mKCaNoiseIC'         ,     0;
  'INso',        'nKNoiseIC'           ,     0;
  'PYso',        'nKNoiseIC'           ,     0;
  'INdr',        'mMNoiseIC'           ,     0;
  'INdr<-PYso',  'neMiniNoiseIC'       ,     0;
  'INdr<-PYso',  'laMiniNoiseIC'       ,     0;
  'PYdr<-PYso',  'neMiniNoiseIC'       ,     0;
  'PYdr<-PYso',  'laMiniNoiseIC'       ,     0;
  'PYdr<-INso',  'neMiniNoiseIC'       ,     0;
  'PYdr<-INso',  'laMiniNoiseIC'       ,     0;
  'PYdr',        'mMNoiseIC'           ,     0;
  'INdr',        'mNaNoiseIC'          ,     0;
  'INdr',        'hNaNoiseIC'          ,     0;
  'INso',        'mNaNoiseIC'          ,     0;
  'INso',        'hNaNoiseIC'          ,     0;
  'PYdr',        'mNaPNoiseIC'         ,     0;
  'PYso',        'mNaPNoiseIC'         ,     0;
  'PYdr',        'mNaNoiseIC'          ,     0;
  'PYdr',        'hNaNoiseIC'          ,     0;
  'PYso',        'mNaNoiseIC'          ,     0;
  'PYso',        'hNaNoiseIC'          ,     0;
  'INdr<-PYso',  'sNMDANoiseIC'        ,     0;
  'PYdr<-PYso',  'sNMDANoiseIC'        ,     0;
  'INdr',        'vNoiseIC'            ,     0;
  'INso',        'vNoiseIC'            ,     0;
  'PYdr',        'vNoiseIC'            ,     0;
  'PYso',        'vNoiseIC'            ,     0;
};

% ------------------------------------------
%% 2. Apply the changes to the model
% ------------------------------------------
output = dsApplyModifications(krishnanSpecification, modifications);
