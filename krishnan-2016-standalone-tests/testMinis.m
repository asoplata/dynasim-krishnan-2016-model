%{
# Test synaptic mini implementation

This is a simple script to test the implementation of the synaptic
    mini mechanism as explained in (Krishnan et al., 2016) and implemented in
    its source code. This synaptic mini model is somewhat different from its
    predecessor, available in the code for (Bazhenov et al., 2002).

- References:
    - Bazhenov M, Timofeev I, Steriade M, Sejnowski TJ. Model of
        thalamocortical slow-wave sleep oscillations and transitions to
        activated states. The Journal of Neuroscience. 2002;22: 8691–8704.
    - Krishnan GP, Chauvette S, Shamie I, Soltani S, Timofeev I, Cash SS, et
        al. Cellular and neurochemical basis of sleep stages in the
        thalamocortical network. eLife. 2016;5: e18607.
%}

%% Parameters
dt = 0.01;

% Note: the next mini time threshold (newrelease) is never generated until at
%   least 70-100 ms after the last event. This is important for the math, since
%   for very low numbers of x-lastrelease1, SS returns EXTREMELY /
%   unrealistically low numbers.
t = 70:dt:1000; % in ms
ti1 = 0; % spike time
ti2 = 100; % spike time
ti3 = 350; % spike time
ti4 = 800; % spike time
ti5 = 850; % spike time

mini_fre = 20;

lastrelease1 = ti1;

S = rand(1);
if S < 0.000001
    S = 0.000001;
end

output1 = zeros(size(t));

for ii=1:length(t)
    output1(ii) = SS(t(ii),lastrelease1,mini_fre);
end

% From their comments, "set when the next mini should go off"
newrelease = -log(S)./output1;
% newrelease = -log(S)./output1;

%% Plotting results
figure()
plot(t, newrelease)

%% Functions
function result = SS(x,lastrelease1,mini_fre)

result = (2.0/(1.0+exp(-(x-lastrelease1)/mini_fre))-1.0)/250.0;

end
