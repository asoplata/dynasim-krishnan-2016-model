function rateValue = iNaThresholdDetector(v, thr, a, q)
%INATHRESHOLDDETECTOR - Change iNa behavior if there is a nonlinearity
%
% This changes the axo-somatic and dendrite iNa (iNa_PYso, iNa_PYdr, iNa_INso,
% iNa_INdr) current behavior when it would otherwise go to infinity /
% divide-by-zero. It is taken from the `trap0` of the original code for (Mainen
% & Sejnowski, 1996) file "cells/na.mod" lines 24-25 and 185-191 (which were
% updated in 2007 to correct a bug), NOT (Krishnan, et al., 2016).
%
% - References:
%     - Krishnan GP, Chauvette S, Shamie I, Soltani S, Timofeev I, Cash SS, et
%         al. Cellular and neurochemical basis of sleep stages in the
%         thalamocortical network. eLife. 2016;5: e18607
%     - Mainen ZF, Sejnowski TJ. Influence of dendritic structure on firing
%         pattern in model neocortical neurons. Nature. 1996;382: 363–366.
%         doi:10.1038/382363a0

rateValue = zeros(1, length(v));

for ii=1:length(v)
    if abs((v(ii) - thr)./q) > 0.000001
        rateValue(ii) = a.*(v(ii)-thr)./(1 - exp(-(v(ii)-thr)./q));
    else
        rateValue(ii) = a.*q;
    end
end
