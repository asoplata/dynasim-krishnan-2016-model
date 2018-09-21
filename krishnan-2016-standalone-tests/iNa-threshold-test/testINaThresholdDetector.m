

v = [-65.02:0.001:-64.98]; % voltage
shift = -10;

vShift = v + shift;
thresholdHBeta = -75;
RHBeta = 0.0091;
qHBeta = 5;

divided = iNaThresholdDetectorDivided(vShift, thresholdHBeta, RHBeta, qHBeta);
% divided = (abs(v./thresholdHBeta) >  0.000001).*RHBeta.*(v-thresholdHBeta)./(1 - exp(-(v-thresholdHBeta)./qHBeta)) + (abs(v./thresholdHBeta) <= 0.000001)*RHBeta.*qHBeta;


figure()
plot(divided, v, '*')

subtracted = iNaThresholdDetectorSubtracted(vShift, thresholdHBeta, RHBeta, qHBeta);
% subtracted = (abs(v-thresholdHBeta) >  0.000001).*RHBeta.*(v-thresholdHBeta)./(1 - exp(-(v-thresholdHBeta)./qHBeta)) + (abs(v-thresholdHBeta) <= 0.000001)*RHBeta.*qHBeta;

figure()
plot(subtracted, v, '*')



%% Part 2
v = [9.98:0.001:10.02]; % vol
shift = -10;
vShift = v + shift;

divided = iNaThresholdDetectorDivided(vShift, thresholdHBeta, RHBeta, qHBeta);
% divided = (abs(v./thresholdHBeta) >  0.000001).*RHBeta.*(v-thresholdHBeta)./(1 - exp(-(v-thresholdHBeta)./qHBeta)) + (abs(v./thresholdHBeta) <= 0.000001)*RHBeta.*qHBeta;


figure()
plot(divided, v, '*')

subtracted = iNaThresholdDetectorSubtracted(vShift, thresholdHBeta, RHBeta, qHBeta);
% subtracted = (abs(v-thresholdHBeta) >  0.000001).*RHBeta.*(v-thresholdHBeta)./(1 - exp(-(v-thresholdHBeta)./qHBeta)) + (abs(v-thresholdHBeta) <= 0.000001)*RHBeta.*qHBeta;

figure()
plot(subtracted, v, '*')
