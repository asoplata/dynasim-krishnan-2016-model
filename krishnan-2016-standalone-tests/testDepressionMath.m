%{
# Test synaptic depression implementations

This scripts tests the difference between implementations of the synaptic
    Depression mechanism as explained in (Chen et al., 2012). In the code for
    both (Krishnan et al., 2016) and (Bazhenov et al., 2002), the synaptic
    depression variable "E" (also called "D" in the papers' equations) in the
    code is ONLY updated at the time of a spike or a mini, even though the
    "flat" value of E is still used at every time point to calculate the
    postsynaptic current. "Dt1Flat" represents the behavior of this
    implementation, and its value only changes when there are events.
    "Dt1Continuous", in contrast, shows what happens when E is continuously
    updated even when there are no events occurring.

While "Dt1Continuous" tends to rise to the same value as "Dt1Flat" when events
    occur, there is definitely a difference when it comes to the non-event
    values of D. This difference may have strong impacts on the resulting
    postsynaptic current being calculated during non-event time.

- References:
    - Bazhenov M, Timofeev I, Steriade M, Sejnowski TJ. Model of
        thalamocortical slow-wave sleep oscillations and transitions to
        activated states. The Journal of Neuroscience. 2002;22: 8691–8704.
    - Chen J-Y, Chauvette S, Skorheim S, Timofeev I, Bazhenov M.
        Interneuron-mediated inhibition synchronizes neuronal activity during
        slow oscillation. The Journal of Physiology. 2012;590: 3987–4010.
        doi:10.1113/jphysiol.2012.227462
    - Krishnan GP, Chauvette S, Shamie I, Soltani S, Timofeev I, Cash SS, et
        al. Cellular and neurochemical basis of sleep stages in the
        thalamocortical network. eLife. 2016;5: e18607.
%}

%% Parameters
dt = 0.01;
t = 0:dt:1000; % in ms
ti1 = 0; % spike time
ti2 = 100; % spike time
ti3 = 350; % spike time
ti4 = 800; % spike time
ti5 = 850; % spike time

U = 0.2;
tau = 500;

Dti1 = 0.9;

output1 = zeros(size(t));
output2 = zeros(size(t));
oldValue = Dti1;

for ii=1:length(t)
    output1(ii) = Dt1Continuous(ii*dt,Dti1,ti1,ti2,ti3,ti4,ti5,U,tau);
    output2(ii) = Dt1Flat(ii*dt,Dti1,ti1,ti2,ti3,ti4,ti5,U,tau,oldValue);
    oldValue = Dt1Flat(ii*dt,Dti1,ti1,ti2,ti3,ti4,ti5,U,tau,oldValue);
end

%% Plotting results
figure()
subplot 211
plot(t, output1)
hold on
plot(t, output2, 'r')
hold off

subplot 212
plot(t, output1 - output2)

%% Functions
function result = Dt1Continuous(x,Dti1,ti1,ti2,ti3,ti4,ti5,U,tau)
% The "0.75" time is supposed to be the D value at the time of the "second" spike, ti2, which is judged by eye
result =                  (x <  ti2).*(1 - (1 - Dti1*(1 - U)) * exp(-(x - ti1)/tau)) + ...
           ((ti2 <= x) && (x < ti3)).*(1 - (1 - 0.77*(1 - U)) * exp(-(x - ti2)/tau)) + ...
           ((ti3 <= x) && (x < ti4)).*(1 - (1 - 0.73*(1 - U)) * exp(-(x - ti3)/tau)) + ...
           ((ti4 <= x) && (x < ti5)).*(1 - (1 - 0.83*(1 - U)) * exp(-(x - ti4)/tau)) + ...
            (ti5 <= x)              .*(1 - (1 - 0.67*(1 - U)) * exp(-(x - ti5)/tau));
end

function result = Dt1Flat(x,Dti1,ti1,ti2,ti3,ti4,ti5,U,tau,oldValue)
if x == 0
    result = 1 - (1 - Dti1*(1 - U)) * exp(-(x - ti1)/tau);
elseif (0 < x) && (x < ti2)
    result = oldValue;
elseif x == ti2
    result = 1 - (1 - Dti1*(1 - U)) * exp(-(x - ti1)/tau);
elseif (ti2 < x) && (x < ti3)
    result = oldValue;
elseif x == ti3
    result = 1 - (1 - Dti1*(1 - U)) * exp(-(x - ti2)/tau);
elseif (ti3 < x) && (x < ti4)
    result = oldValue;
elseif x == ti4
    result = 1 - (1 - Dti1*(1 - U)) * exp(-(x - ti3)/tau);
elseif (ti4 < x) && (x < ti5)
    result = oldValue;
elseif x == ti5
    result = 1 - (1 - Dti1*(1 - U)) * exp(-(x - ti4)/tau);
elseif x > ti5
    result = oldValue;
end
end
