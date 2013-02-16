function dhdxNorm = dhdxNormalize(dhdxVaryX, NTVaryX)

dhdxNorm = zeros(size(dhdxVaryX));

for i = 1:size(dhdxVaryX, 1)
    
    dhdxNorm(i, :) = dhdxVaryX(i, :) ./ NTVaryX;
    
end % for

plot(NTVaryX, dhdxNorm(1:3, :)');
title('dhdx Running Time (Normalized) Vs. Scale (N {\times} T)');
xlabel('Scale (N {\times} T)');
ylabel('Running Time (Seconds)');
legend('Total Running Time', 'Running Time Before For Loops', ...
    'Running Time After For Loops', 'Location', 'Northwest');

figure();
ColorSet = hsv(10);
set(gca, 'ColorOrder', ColorSet);
hold all;
plot(NTVaryX, dhdxNorm(4:11, :)');
title('Individual dhdx Function Running Times (Normalized) Vs. Scale (N {\times} T)');
xlabel('Scale (N {\times} T)');
ylabel('Running Time / (N {\times} T)');
legend('rhoConstraints', 'lConstraints', 'delConstraints', ...
    'sigConstraints', 'dConstraints', 'fInConstraints', ...
    'fOutConstraints', 'rConstraints', 'Location', 'Northwest');
hold off;

end % dhdxNorm