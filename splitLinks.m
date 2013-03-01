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

currUnsplitLinks = unsplitScen.links;
currUnsplitDemand = unsplitScen.BC.D;

while true
    splitLinks = [];
    splitCounter = 0;
    [numTimeSteps, numLinks] = size(currUnsplitDemand);
    for i = 1:numLinks
        if currUnsplitLinks(i).v / currUnsplitLinks(i).L < 0.5
            splitLinkBegin = currUnsplitLinks(i);
            splitLinkBegin.L = currUnsplitLinks(i).L / 2;
            splitLinkEnd = currUnsplitLinks(i);
            splitLinkEnd.L = currUnsplitLinks(i).L / 2;
            splitLinkEnd.rmax = 0;
            splitLinks = [splitLinks, splitLinkBegin, splitLinkEnd];
            splitDemand = [currUnsplitDemand(:, 1:(i + splitCounter)) ...
                zeros(numTimeSteps, 1), currUnsplitDemand(:, (i + 1 + ... 
                splitCounter):end)];
            splitCounter = splitCounter + 1;
            currUnsplitDemand = splitDemand;
        else
            splitLinks = [splitLinks, currUnsplitLinks(i)];
        end % end if
    end % end for
    if length(currUnsplitLinks) == length(splitLinks)
        break;
    end % end if
    currUnsplitLinks = splitLinks;
end % end while

splitScen = struct('links', splitLinks, 'BC', splitDemand);

for i = 1:length(splitScen.links)
    disp(splitScen.links(i).v/splitScen.links(i).L);
end 

end % end splitLinks