function splitScen = splitLinks(unsplitScen)
% PURPOSE:
% Checks the ratio of the length, L, to the free-flow speed, v, of each
% link. If the ratio, v/L, is less than 0.5, the link is split iteratively
% until the ratio exceeds 0.5. The attributes of the split links will have
% the same attributes as the unsplit link. Any onramps associated with the
% unsplit link will be associated with the first split link.
%
% INPUTS:
% unsplitScen - A scenario, given in the JSON format.
%
% OUTPUTS:
% splitScen - A scenario, given in the JSON format. For each link, v/L will
%  not be less than 0.5.

unsplitLinks = unsplitScen.links;
unsplitDemand = unsplitScen.BC.D;
unsplitBeta = unsplitScen.BC.beta;

while true
    splitLinks = [];
    splitCounter = 0;
    [numTimeSteps, numLinks] = size(unsplitDemand);
    for i = 1:numLinks
        if unsplitLinks(i).v / unsplitLinks(i).L < 0.5
            splitLinkBegin = unsplitLinks(i);
            splitLinkBegin.L = unsplitLinks(i).L / 2;
            splitLinkEnd = unsplitLinks(i);
            splitLinkEnd.L = unsplitLinks(i).L / 2;
            splitLinkEnd.rmax = 0;
            splitLinks = [splitLinks, splitLinkBegin, splitLinkEnd];
            splitDemand = [unsplitDemand(:, 1:(i + splitCounter)), ...
                zeros(numTimeSteps, 1), unsplitDemand(:, (i + 1 + ... 
                splitCounter):end)];
            splitBeta = [unsplitBeta(:, 1:(i + splitCounter)), ...
                ones(numTimeSteps, 1), unsplitBeta(:, (i + 1 + ...
                splitCounter):end)];
            splitCounter = splitCounter + 1;
            unsplitDemand = splitDemand;
            unsplitBeta = splitBeta;
        else
            splitLinks = [splitLinks, unsplitLinks(i)];
        end % end if
    end % end for
    if length(unsplitLinks) == length(splitLinks)
        break;
    end % end if
    unsplitLinks = splitLinks;
end % end while

unsplitScen.links = splitLinks;
unsplitScen.BC.D = splitDemand;
unsplitScen.BC.beta = splitBeta;
unsplitScen.N = length(unsplitScen.links);
unsplitScen.IC.l0 = zeros(1, unsplitScen.N);
unsplitScen.IC.p0 = zeros(1, unsplitScen.N);
unsplitScen.nConstraints = (unsplitScen.T + 1) * unsplitScen.N * 8;
unsplitScen.nControls = unsplitScen.T * unsplitScen.N;

splitScen = unsplitScen;

end % end splitLinks