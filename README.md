# DynaSim mechanism files for simulating (Krishnan et al., 2016)

 DynaSim-compatible mechanism files for simulation of the cortex and thalamus of
 (Krishnan et al., 2016).

Adding these mechanism files and associated functions into where you keep your
mechanism files for [DynaSim](https://github.com/DynaSim/DynaSim), e.g.
`/your/path/to/dynasim/models`, should enable you to simulate the computational
cortex and thalamus from:

    Krishnan GP, Chauvette S, Shamie I, Soltani S, Timofeev I, Cash SS, et al.
    Cellular and neurochemical basis of sleep stages in the thalamocortical
    network. eLife. 2016;5: e18607.

The original code for the (Krishnan et al., 2016) model (which is not public)
seems to be inherited in part from the code of (Bazhenov et al., 2002), which
can be found [here at
ModelDB](https://senselab.med.yale.edu/ModelDB/ShowModel.cshtml?model=28189).

Note that this is only intended to reproduce the qualitative behavior of the
"base", not the "extended" model of the paper. That said, there are experimental
adjustment factors in the code that would make modeling the extended model easy.
Also note that this is NOT intended as a bit-perfect reproduction of the
original model, but rather just an open-source, adequate reproduction of the
overall qualitative results.

## Install and Usage

The easiest way to get started with this is:

1. Install DynaSim (https://github.com/DynaSim/DynaSim/wiki/Installation),
   including adding it to your MATLAB path.
2. `git clone` or download this code's repo
   (https://github.com/asoplata/dynasim-krishnan-2016-model) into
   '/your/path/to/dynasim/models', i.e. the 'models' subdirectory of your
   copy of the DynaSim repo.
3. Run the main runscript `runKrishnanModel.m`.
4. Believe it or not...that should be it! You should be able to start MATLAB
   in your DynaSim code directory and run this script successfully!  Let me
   know if there are problems, at austin.soplata 'at-symbol-thingy' gmail
   'dot' com

## References

1. Bazhenov M, Timofeev I, Steriade M, Sejnowski TJ. Model of thalamocortical
   slow-wave sleep oscillations and transitions to activated states. The Journal
   of Neuroscience. 2002;22: 8691–8704. 
2. Krishnan GP, Chauvette S, Shamie I, Soltani S, Timofeev I, Cash SS, et al.
   Cellular and neurochemical basis of sleep stages in the thalamocortical
   network. eLife. 2016;5: e18607.
