function jsonScen = convertBeatsToScenario(fileName)

beatsScen = io.xml_read(fileName);
numLinks = length(beatsScen.NetworkList.network.LinkList.link);
numNodes = length(beatsScen.NetworkList.network.NodeList.node);

% Store node IDs and find terminal nodes.
nodeIDs = [];
termNodes = [];
for i = 1:numNodes
    currNode = beatsScen.NetworkList.network.NodeList.node(i);
    nodeIDs(i) = currNode.ATTRIBUTE.id;
    if strcmp(currNode.ATTRIBUTE.type, 'terminal')
        termNodes = [termNodes, nodeIDs(i)];
    end % if
end % for i

% Store link IDs and find source, freeway, on-ramp, and off-ramp links.
linkIDs = [];
sourceLinks = [];  % Stores the IDs for the source links.
sourceNodes = [];  % Stores the begin node IDs for the source links.
freewayLinks = []; % Each row is a link, with ID, begin node, and end node.
onRampLinks = [];  % Each row is a link, with ID, begin node, and end node.
offRampLinks = []; % Each row is a link, with ID, begin node, and end node.
for i = 1:numLinks
    currLink = beatsScen.NetworkList.network.LinkList.link(i);
    currBeginNode = currLink.begin.ATTRIBUTE.node_id;
    currEndNode = currLink.xEnd.ATTRIBUTE.node_id;
    linkIDs(i) = currLink.ATTRIBUTE.id;
    if strcmp(currLink.ATTRIBUTE.type, 'freeway')
        freewayLinks = [freewayLinks; linkIDs(i), currBeginNode, currEndNode];
        if ismember(currBeginNode, termNodes)
            sourceLinks = [sourceLinks, linkIDs(i)];
            sourceNodes = [sourceNodes, currBeginNode];
        end % if
    elseif strcmp(currLink.ATTRIBUTE.type, 'onramp');
        onRampLinks = [onRampLinks; linkIDs(i), currBeginNode, currEndNode];
    elseif strcmp(currLink.ATTRIBUTE.type, 'offramp');
        offRampLinks = [offRampLinks; linkIDs(i), currBeginNode, currEndNode];
    end % if
end % for i

% Check that there is exactly one freeway source link.
if length(sourceNodes) ~= 1
    error('There must be exactly one freeway source link.');
end % if

% Construct network.
currNodeID = sourceNodes;
freewayLinksList = {};
nodesList = {};
demandProfile = beatsScen.DemandProfileSet.demandProfile;

while true
    currNode = beatsScen.NetworkList.network.NodeList.node(nodeIDs == currNodeID);
    nodesList{end + 1} = currNode;
    
    % Find output links from current node.
    outputLinks = find(currNodeID == freewayLinks(:, 2));
    
    % If there are no more output links, we have reached the end the network.
    if isempty(outputLinks)
        break;
    end % if
    
    % Check that there is at most one output link.
    if length(outputLinks) > 1
        error('There must be at most one output link for every node.');
    end % if
    
    currLinkID = freewayLinks(outputLinks, 1);
    currLink = beatsScen.NetworkList.network.LinkList.link(linkIDs == currLinkID);
    
    % Check if there is any on-ramp links to the current node.
    if any(onRampLinks(:, 3) == currNodeID)
        currLink.onRamp = true;
        % Add demand to the on-ramp.
        for i = 1:length(demandProfile)
            currDemand = demandProfile(i);
            currDemandLinkID = currDemand.ATTRIBUTE.link_id_origin;
            currDemandNodeID = onRampLinks(onRampLinks(:, 1) == currDemandLinkID, 3);
            if currNodeID == currDemandNodeID
                onrampDT = currDemand.ATTRIBUTE.dt;
                onrampDemand = currDemand.CONTENT;
                % Find the corresponding onramp capacity.
                for j = 1:length(beatsScen.FundamentalDiagramProfileSet.fundamentalDiagramProfile)
                    tempFD = beatsScen.FundamentalDiagramProfileSet.fundamentalDiagramProfile(j);
                    if tempFD.ATTRIBUTE.link_id == currDemandLinkID
                        onrampRmax = tempFD.fundamentalDiagram.ATTRIBUTE.capacity;
                        break;
                    end % if
                end % end for j
                currLink.dt = onrampDT;
                currLink.demand = onrampDemand;
                currLink.rmax = onrampRmax;
                break;
            end % if
        end % for i
    end % if
    
    if ~isfield(currLink, 'demand')
        currLink.onRamp = false;
        currLink.dt = 0;
        currLink.demand = [];
        currLink.rmax = 0;
    end % if
    
    for i = 1:length(beatsScen.SplitRatioProfileSet.splitratioProfile.splitratio)
        currSplitRatio = beatsScen.SplitRatioProfileSet.splitratioProfile.splitratio(i);
        currBeta = currSplitRatio.CONTENT;
        currBetaLinkIn = currSplitRatio.ATTRIBUTE.link_in;
        currBetaLinkOut = currSplitRatio.ATTRIBUTE.link_out;
        % Attach the split ratio to the corresponding link.
        if currBetaLinkIn == currLinkID
            % Check that the link out is a freeway link, rather than an offramp.
            if any(ismember(freewayLinks(:, 1), currBetaLinkOut)) 
                currLink.beta = currBeta;
            end % end if
        end % end if
    end % end for i
    
    if ~isfield(currLink, 'beta')
        currLink.beta = 1;
    end % end if
    
    freewayLinksList{end + 1} = currLink;
    currNodeID = currLink.xEnd.ATTRIBUTE.node_id;
    
end % while

% Attach the source link as a demand to the initial freeway link.
sourceLinkID = sourceLinks;
sourceLinkEndNode = freewayLinks(freewayLinks(:, 1) == sourceLinkID, 3);
nextLinkID = freewayLinks(freewayLinks(:, 2) == sourceLinkEndNode, 1);

for i = 1:length(demandProfile)
    currDemandLinkID = demandProfile(i).ATTRIBUTE.link_id_origin;
    if sourceLinkID == currDemandLinkID
        sourceDT = demandProfile(i).ATTRIBUTE.dt;
        sourceDemand = demandProfile(i).CONTENT;
        % Find the source onramp capacity.
        for j = 1:length(beatsScen.FundamentalDiagramProfileSet.fundamentalDiagramProfile)
            tempFD = beatsScen.FundamentalDiagramProfileSet.fundamentalDiagramProfile(j);
            if tempFD.ATTRIBUTE.link_id == currDemandLinkID
                sourceRmax = tempFD.fundamentalDiagram.ATTRIBUTE.capacity;
                break;
            end % if
        end % end for j
        for k = 1:length(freewayLinksList)
            if freewayLinksList{i}.ATTRIBUTE.id == nextLinkID
                freewayLinksList{i}.onRamp = true;
                freewayLinksList{i}.dt = sourceDT;
                freewayLinksList{i}.demand = sourceDemand;
                freewayLinksList{i}.rmax = sourceRmax;
            end % if
        end % for k
    end % if
end % for i
freewayLinksList(1) = []; % Remove the source link from the list of freeway links.

freewayLinksList = [freewayLinksList{:}];
nodesList = [nodesList{:}];

scenDT = beatsScen.NetworkList.network.ATTRIBUTE.dt; % dt is given in seconds.
convFactor = scenDT / 3600; % Conversion factor from per hour to per "unit" time, i.e. dt.

% Convert to from current struct to a scenario struct.
for i = 1:length(freewayLinksList)
    currLink = freewayLinksList(i);
    % Find the corresponding fundamental diagram.
    for j = 1:length(beatsScen.FundamentalDiagramProfileSet.fundamentalDiagramProfile)
        tempFD = beatsScen.FundamentalDiagramProfileSet.fundamentalDiagramProfile(j);
        if tempFD.ATTRIBUTE.link_id == currLink.ATTRIBUTE.id
            currFD = tempFD.fundamentalDiagram;
            break;
        end % if
    end % end for j
    scenLinks(i).w = currFD.ATTRIBUTE.congestion_speed * convFactor; % Convert from mi/h to mi/"unit".
    scenLinks(i).v = currFD.ATTRIBUTE.free_flow_speed * convFactor; % Convert from mi/h to mi/"unit".
    scenLinks(i).fm = currFD.ATTRIBUTE.capacity * convFactor; % Convert from veh/h to veh/"unit".
    scenLinks(i).p = 0.8;
    scenLinks(i).rmax = currLink.rmax * convFactor; % Convert from veh/h to veh/"unit".
    scenLinks(i).L = currLink.ATTRIBUTE.length;
    scenLinks(i).pc = scenLinks(i).fm / scenLinks(i).v;
    scenLinks(i).pm = currFD.ATTRIBUTE.jam_density;
    scenBC(i).beta = currLink.beta;
    scenBC(i).dt = currLink.dt;
    scenBC(i).D = currLink.demand * convFactor; % Convert from veh/h to veh/"unit".
end % for

% Convert to JSON scenario.
links = scenLinks;

N = length(scenLinks);

for i = 1:length(scenBC)
    demandDTs(i) = scenBC(i).dt;
end % for i
maxDemandDT = max(demandDTs);

T = maxDemandDT / scenDT;
dt = 1;
nConstraints = (T + 1) * N * 8;
nControls = T * N;
processU = @(u) unstack(u, scen);

% Create initial conditions.
l0 = zeros(1, N);
p0 = zeros(1, N);
IC = struct('l0', l0, 'p0', p0);

% Create split ratios network.
beta = zeros(T, N);
for i = 1:N
    currLinkDT = scenBC(i).dt;
    for j = 1:T
        if (j * dt) <= currLinkDT
            beta(j, i) = scenBC(i).beta;
        else
            beta(j, i) = 1;
        end
    end 
end

% Create demand matrix.
D = zeros(T, N);
for i = 1:N
    currLinkDT = scenBC(i).dt;
    for j = 1:T
        if (j * dt) <= currLinkDT
            D(j, i) = scenBC(i).D;
        else
            D(j, i) = 0;
        end % if
    end % for j
end % for i

BC = struct('D', D, 'beta', beta);

jsonScen = struct('links', links, 'BC', BC, 'IC', IC, 'N', N, 'T', T, ...
    'dt', dt, 'nConstraints', nConstraints, 'nControls', nControls, ...
    'processU', processU);

% Split links into smaller links if the ratio v/L exceeds 0.5.
jsonScen = io.splitLinks(jsonScen);

% Binary search to find the optimal demand matrix, ensuring that the
% network is cleared and minimizing the number of time steps that have no
% densities.
D = jsonScen.BC.D;
beta = jsonScen.BC.beta;
lowBound = 0;
highBound = 2 * T;
% i = 0;

while (lowBound <= highBound)
    midBound = floor((lowBound + highBound) / 2);
    % Check if the binary search is working as intended.
    % i = i + 1;
    % disp(['Current trial is ', num2str(i), ', with lowBound = ', num2str(lowBound), ' and highBound = ', num2str(highBound), '.']);
    
    % Terminates the loop if a "perfect" demand profile cannot be
    % generated, i.e. neither of the termination conditions can be 
    % satisfied. Returns the current optimal demand profile.
    if (midBound == lowBound || midBound == highBound)
        break;
    end % end if
    
    testD = [D; zeros(midBound, size(D, 2))];
    jsonScen.BC.D = testD;
    jsonScen.T = size(jsonScen.BC.D, 1);
    jsonScen.BC.beta = [beta; ones(midBound, size(beta, 2))];
    jsonScen.nConstraints = (jsonScen.T + 1) * jsonScen.N * 8;
    jsonScen.nControls = jsonScen.T * jsonScen.N;
    
    u = chooseInitialU(jsonScen);
    outputState = forwardSimulation(jsonScen, u);
    
    if sum(outputState.density(end, :)) > 1
        lowBound = midBound;
        highBound = 2 * highBound;
    elseif sum(outputState.density(end - 1, :)) < 1
        highBound = midBound;
    else
        break;
    end % end if
end % end while

% Check the CFL condition.
% for i = 1:length(jsonScen.links)
%     currCFL = jsonScen.links(i).v / jsonScen.links(i).L;
%     dispMsg = ['v/L for link ', num2str(i), ' is ', num2str(currCFL), '.'];
%     disp(dispMsg);
% end % end for i

end % convertBeatsToScenario