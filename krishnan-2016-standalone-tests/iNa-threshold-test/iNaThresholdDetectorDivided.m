function rateValue = iNaThresholdDetectorDivided(v, thr, a, q)
% This is taken from the `trap0` of the original code for the following paper:
%
% - Reference: "Krishnan GP, Chauvette S, Shamie I, Soltani S, Timofeev I, Cash
%     SS, et al. Cellular and neurochemical basis of sleep stages in the
%     thalamocortical network. eLife. 2016;5: e18607"

rateValue = zeros(size(v, 2), 1);

for ii=1:length(v)
    if abs(v(ii)./thr) > 0.000001
        rateValue(ii) = a.*(v(ii)-thr)./(1 - exp(-(v(ii)-thr)./q));
    else
        rateValue(ii) = a*q;
    end
end
