function dhdxNorm = dhdxNormalize(NTVaryX, dhdxVaryX)
% PURPOSE:
% To "normalize" the dhdxVaryX vs. NTVaryX plots by dividing each value of
% dhdxVaryX by the corresponding value of NTVaryX. Inputs are generated
% from the program, dhdxScaling.

% OUTPUTS:
% 1. dhdxNorm: A matrix of the "normalized" times for various functions in 
%    dh_dx. The various functions are separated into the following rows:
%        1. dh_dx,
%        2. for loop iterations,
%        3. sparse matrix creation,
%        4. rhoConstraints,
%        5. lConstraints,
%        6. delConstraints,
%        7. sigConstraints,
%        8. dConstraints,
%        9. fInConstraints,
%       10. fOutConstraints, and
%       11. rConstraints.
% 2. A plot of the "normalized" times for various functions in dh_dx 
%    against the scale of the scenario, where the the scale is determined 
%    by the product N * T.

% INPUTS:
% 1. NTVaryX: An array of products, N * T, with holding one variable
%    constant and varying the other variable, X. NTVaryX is an output from
%    dhdxScaling.
% 2. dhdxVaryX: A matrix of the times for various functions in dh_dx. The
%    various functions are separated into the same rows as the output,
%    dhdxNorm. dhdxVaryX is an output from dhdxScaling.


dhdxNorm = zeros(size(dhdxVaryX));

for i = 1:size(dhdxVaryX, 1)
    
    dhdxNorm(i, :) = dhdxVaryX(i, :) ./ NTVaryX;
    
end % for

plot(NTVaryX, dhdxNorm(1:3, :));
title('dhdx Running Time (Normalized) Vs. Scale (N {\times} T)');
xlabel('Scale (N {\times} T)');
ylabel('Running Time (Seconds)');
legend('Total Running Time', 'Running Time Before For Loops', ...
    'Running Time After For Loops', 'Location', 'Northwest');

figure();
ColorSet = hsv(10);
set(gca, 'ColorOrder', ColorSet);
hold all;
plot(NTVaryX, dhdxNorm(4:11, :));
title('Individual dhdx Function Running Times (Normalized) Vs. Scale (N {\times} T)');
xlabel('Scale (N {\times} T)');
ylabel('Running Time / (N {\times} T)');
legend('rhoConstraints', 'lConstraints', 'delConstraints', ...
    'sigConstraints', 'dConstraints', 'fInConstraints', ...
    'fOutConstraints', 'rConstraints', 'Location', 'Northwest');
hold off;

end % dhdxNorm