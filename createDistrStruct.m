function [distrStruct] = createDistrStruct()
% Creates a struct of distributions for variables used in createScenario.

% For most of the variables, the available distributions can be a constant,
% random numbers within a range, or a Gaussian. 

wDistr = input('Distribution for wave speeds? ', 's');
% Default wave speed distribution is random, between 0.5 and 1.
if isempty(wDistr)
    wDistr = '0.5, 1';
end

vDistr = input('Distribution for free-flow speeds? ', 's');
% Default free-flow speeds are 1.
if isempty(vDistr)
    vDistr = '1';
end

fmDistr = input('Distribution for maximum flows? ', 's');
% Default maximum flow distribution is random, between 0.5 and 1.
if isempty(fmDistr)
    fmDistr = '0.5, 1';
end

pDistr = input('Distribution for priorities? ', 's');
% Default priorities are 0.8.
if isempty(pDistr)
    pDistr = '0.8';
end

rmaxDistr = input('Distribution for maximum ramp outflows? ', 's');
% Default maximum ramp outflow distribution is random, between 0.5 and 1.
if isempty(rmaxDistr)
    rmaxDistr = '0.5, 1';
end

LDistr = input('Distribution for link lengths? ', 's');
% Default link length is 1.
if isempty(LDistr)
    LDistr = '1';
end

DDistr = input('Distribution for demands? ', 's');
% Default demand distribution is Gaussian.
if isempty(DDistr)
    DDistr = 'Gaussian';
end

betaDistr = input('Distribution for split ratios? ', 's');
% Default split ratio distribution is random, between 0.1 and 1.
if isempty(betaDistr)
    betaDistr = '0.1, 1';
end

l0Distr = input('Distribution for initial queues? ', 's');
% Default initial queue distribution is random, between 0 and 1.
if isempty(l0Distr)
    l0Distr = '0, 1';
end

p0Distr = input('Distribution for initial densities? ', 's');
% Default initial density distribution is random, between 0 and 1.
if isempty(p0Distr)
    p0Distr = '0, 1';
end

end % end createDistrStruct