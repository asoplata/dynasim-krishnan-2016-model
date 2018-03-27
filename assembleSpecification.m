function specification = assembleSpecification(dt, numCellsScaledown)
%ASSEMBLESPECIFICATION - Construct and connect the (Krishnan et al., 2016) model
%
% assembleSpecification builds a (Krishnan et al., 2016)-type DynaSim
% specification, including both its populations and connections from the many
% mechanism files contained in the 'models/' subdirectory.
%
% Inputs:
%   'dt': time resolution of the simulation, in ms
%   'numCellsScaledown': number to multiply each cell population size
%                        by, between 0 and 1. To run the full model, use 
%                        1. If one wishes to run a smaller model, since 
%                        the default model is rather large, use a 
%                        smaller proportion like 0.2.
%
% Outputs:
%   'specification': DynaSim specification structure for the (Krishnan
%                    et al., 2016) model.
%
% Note: By default, the specification output by this function is set to the
%   'Awake' behavioral state as used in (Krishnan et al., 2016). To change
%   this, use the `applyExperimentFactors.m` function.
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


% -------------------------------------------------------------------
%% 1. Make master equations and initialize
% -------------------------------------------------------------------
% Define equations of cell model (same for all populations)
eqns={
  'dv/dt=(@current)/Cm'
  'Cm = 0.75' % uF/cm^2
  'thresh=-20'
  'monitor v.spikes(thresh, 1)'
  'v(0)=-65+5*rand(1,Npop)'
};

% WARNING: Until indicated otherwise, only use the 'euler' integration when
%     using these soma equations. Use of non-euler integration may contain a
%     small amount of error due to the 'v(t-dt)' not being interpolated
%     correctly for "intermediary" timesteps during the integration/solution
%     process.
% Note that the voltage for the axo-somatic compartment is calculated using
%     a "reduced form" derived from dv/dt=0, NOT using the normal dv/dt method.
%     For an explanation of this, see (Chen et al., 2012) page 5, section
%     'Intrinsic currents - cortex', first paragraph.
eqns_soma = {
strcat(['dv/dt=((@voltage + (kappa*S_SOMA.*(@current+6.74172)))./' ...
               '(1 + kappa*S_SOMA.*(@conductance)) - v(t-'],num2str(dt),'))./',num2str(dt))
  'kappa=10e3'  % kOhms
  'S_SOMA=1e-6' % cm^2
  'v(0) = -60+5*rand(1,Npop)'
  'thresh=-20'
  'monitor v.spikes(thresh, 1)'
};

% Initialize DynaSim specification structure
specification=[];

% -------------------------------------------------------------------
%% 2. Assemble Cortex Model and Intracortical Connections
% -------------------------------------------------------------------
% PY cells and intercompartmental PY connections:
specification.populations(1).name='PYdr';
specification.populations(1).size=round(numCellsScaledown*500);
specification.populations(1).equations=eqns;
specification.populations(1).mechanism_list={...
    'iAppliedCurrent',...
    'iKLeak_PYdr',...
    'iLeak_PYdr',...
    'iNa_PYdr',...
    'iNaP_PYdr',...
    'CaBuffer_PYdr', 'iHVA_PYdr','iKCa_PYdr',...
    'iM_PYdr',...
    };

% Note that the soma mechanisms are somewhat sensitive to initial conditions
specification.populations(2).name='PYso';
specification.populations(2).size=round(numCellsScaledown*500);
specification.populations(2).equations=eqns_soma;
specification.populations(2).mechanism_list={...
    'iNa_PYso',...
    'iK_PYso',...
    'iNaP_PYso',...
    };

specification.connections(1).direction='PYso<-PYdr';
specification.connections(1).mechanism_list={'iCOM_PYso_PYdr'};
specification.connections(2).direction='PYdr<-PYso';
specification.connections(2).mechanism_list={...
    'iCOM_PYdr_PYso',...
    'iAMPAdepr_PYdr_PYso',...
    'iMiniAMPA_PYdr_PYso',...
    'iNMDA_PYdr_PYso'};

% IN cells and intercompartmental IN connections:
specification.populations(3).name='INdr';
specification.populations(3).size=round(numCellsScaledown*100);
specification.populations(3).equations=eqns;
specification.populations(3).mechanism_list={...
    'iAppliedCurrent',...
    'iKLeak_INdr',...
    'iLeak_INdr',...
    'iNa_INdr',...
    'iHVA_INdr','CaBuffer_INdr','iKCa_INdr',...
    'iM_INdr',...
    };

% Note that the soma mechanisms are somewhat sensitive to initial conditions
specification.populations(4).name='INso';
specification.populations(4).size=round(numCellsScaledown*100);
specification.populations(4).equations=eqns_soma;
specification.populations(4).mechanism_list={...
    'iNa_INso',...
    'iK_INso',...
    };

specification.connections(3).direction='INso<-INdr';
specification.connections(3).mechanism_list={'iCOM_INso_INdr'};
specification.connections(4).direction='INdr<-INso';
specification.connections(4).mechanism_list={'iCOM_INdr_INso'};

% PY<->IN connections/synapses
specification.connections(5).direction='INdr<-PYso';
specification.connections(5).mechanism_list={...
    'iAMPAdepr_INdr_PYso',...
    'iMiniAMPA_INdr_PYso',...
    'iNMDA_INdr_PYso'};

specification.connections(6).direction='PYdr<-INso';
specification.connections(6).mechanism_list={...
    'iGABAAdepr_PYdr_INso',...
    'iMiniGABAA_PYdr_INso'};

% -------------------------------------------------------------------
%% 3. Assemble Thalamic Model and Intrathalamic Connections
% -------------------------------------------------------------------
specification.populations(5).name='TC';
specification.populations(5).size=round(numCellsScaledown*100);
specification.populations(5).equations=eqns;
specification.populations(5).mechanism_list={...
    'iAppliedCurrent',...
    'iNa_TC',...
    'iK_TC',...
    'iLeak_TC',...
    'iKLeak_TC',...
    'CaBuffer_TC','iT_TC','iH_TC'};

specification.populations(6).name='NRT';
specification.populations(6).size=round(numCellsScaledown*100);
specification.populations(6).equations=eqns;
specification.populations(6).mechanism_list={...
    'iAppliedCurrent',...
    'iNa_NRT',...
    'iK_NRT',...
    'iLeak_NRT',...
    'iKLeak_NRT',...
    'CaBuffer_NRT','iT_NRT'};

specification.connections(7).direction='TC<-NRT';
specification.connections(7).mechanism_list={...
    'iGABAA_TC_NRT',...
    'iGABAB_TC_NRT'};
specification.connections(8).direction='NRT<-NRT';
specification.connections(8).mechanism_list={'iGABAA_NRT_NRT'};
specification.connections(9).direction='NRT<-TC';
specification.connections(9).mechanism_list={'iAMPA_NRT_TC'};

% -------------------------------------------------------------------
%% 4. Thalamo-cortical Connections
% -------------------------------------------------------------------
specification.connections(10).direction='PYdr<-TC';
specification.connections(10).mechanism_list={'iAMPAdepr_PYdr_TC'};

specification.connections(11).direction='INdr<-TC';
specification.connections(11).mechanism_list={'iAMPAdepr_INdr_TC'};

specification.connections(12).direction='TC<-PYso';
specification.connections(12).mechanism_list={'iAMPA_TC_PYso'};

specification.connections(13).direction='NRT<-PYso';
specification.connections(13).mechanism_list={'iAMPA_NRT_PYso'};
