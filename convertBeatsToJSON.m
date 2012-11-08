function out = convertBeatsToJSON(varargin)
fnin = varargin{1};
if nargin == 2
    fnout = varargin{2};
else
    fnout = [fnin(1:end - 3) 'json'];
end
% read node list and directions cache
disp('Reading configuration file')
scenario = xml_read(fnin);

% find terminal nodes
isterminal = [];
for i=1:length(scenario.network.NodeList.node)
    if(isempty(scenario.network.NodeList.node(i).inputs))
        isterminal = [isterminal scenario.network.NodeList.node(i).ATTRIBUTE.id];
    end
    nodeid(i) = scenario.network.NodeList.node(i).ATTRIBUTE.id;
end

% find mainline links with terminal begin node
sourceFWid = [];
fwlink2beginnode = [];
orlink2endnode = [];
for i=1:length(scenario.network.LinkList.link)
    link = scenario.network.LinkList.link(i);
    linkid(i) = link.ATTRIBUTE.id;
    if(strcmp(link.ATTRIBUTE.type,'FW'))
        begin_node = link.begin.ATTRIBUTE.node_id;
        fwlink2beginnode = [fwlink2beginnode;[linkid(i) begin_node]];
        if(ismember(begin_node,isterminal))
            sourceFWid = [sourceFWid begin_node];
        end
    end
    if(strcmp(link.ATTRIBUTE.type,'OR'))
        orlink2endnode(end+1) = link.xEnd.ATTRIBUTE.node_id;
    end
end


% check that there is exactly one of these
if(length(sourceFWid)~=1)
   disp('This works on networks with exactly one mainline source');
   return
end

clc;
% contruct freeway network
cNodeId = sourceFWid;
fwlinksid = [];
fwlinks = {};
nodes = {};
demand = scenario.DemandProfileSet.demand;
while(1)
    currentNode = scenario.network.NodeList.node(nodeid==cNodeId);
    nodes{end+1} = currentNode;
    
    % find list of freeway output links
    outFwLinks = find(cNodeId==fwlink2beginnode(:,2));
    
    if(isempty(outFwLinks))
        disp('end reached')
        break;
    end
    
    if(length(outFwLinks)>1)
        disp('freeway diverge connectors not supported')
        break;
    end
    nextlinkid = fwlink2beginnode(outFwLinks,1);
    fwlinksid = [fwlinksid nextlinkid];
    nextlink = scenario.network.LinkList.link(linkid==nextlinkid);
    cNodeId = nextlink.xEnd.ATTRIBUTE.node_id;
    % is there an onramp here?
    if any(orlink2endnode(orlink2endnode==cNodeId))
        nextlink.onramp = true;
        % add some demand to this sucker
        for i = 1:length(demand)
            check = demand(i);
            if check.ATTRIBUTE.link_id == cNodeId
                dt = check.ATTRIBUTE.dt;
                try
                    data = check.CONTENT;
                    first_split = strsplit(data,',');
                    second_split = [];
                    for j = 1:length(first_split)
                        data = first_split{j};
                        nother = strsplit(data,':');
                        second_split(end+1) = str2double(nother{1});
                    end
                    nextlink.demand = second_split;
                catch e
                    nextlink.demand = [];
                end
                nextlink.demand_dt = dt;
                break;
            end
        end            
    end
    if ~isfield(nextlink,'demand')
        nextlink.onramp = false;
        nextlink.demand = [];
        nextlink.demand_dt = 0;
    end
    fwlinks{end+1} = nextlink;
end
fwlinks = [fwlinks{:}];
nodes = [nodes{:}];

% CLEAN UP REPRESENTATION
for i = 1:length(fwlinks)
    link = fwlinks(i);
    nl(i).rj = link.fd.ATTRIBUTE.densityJam;
    nl(i).rc = link.fd.ATTRIBUTE.densityCritical;
    nl(i).fm = link.fd.ATTRIBUTE.flowMax;
    nl(i).l = link.ATTRIBUTE.length;
    nl(i).beta = .5;
    nl(i).p = .5;
    nl(i).dt = link.demand_dt;
    nl(i).d = link.demand;
    nl(i).v = nl(i).fm / nl(i).rc;
    nl(i).w = nl(i).fm / (nl(i).rj - nl(i).rc);
end


% convert to our format
json.v = [nl.v];
json.w = [nl.w];
json.fm = [nl.fm];
json.beta = [nl.beta];
json.L = [nl.l];
%% NO INIITIAL CONDITIONS BUILT IN YET, DEAL WITH IT
json.l0 = zeros(size(json.v));
json.p0 = zeros(size(json.v));
json.p = [nl.p];
for i = 1:length(nl) - 1
    if ~isempty(nl(i).d)
        json.D(i,1:length(nl(i).d)) = nl(i).d;
    else
        json.D(i,1) = 0;        
    end
end
%% need to fix this as well, to allow downstream flux
json.D = json.D';
json.D0 = zeros(1, size(json.D, 1));
json.R = .1;
json.dt = scenario.network.ATTRIBUTE.dt;
%% THERE'S A BUG IN OUR CODE IF SOMETHING IS ACTUALLY USING DX
json.dx = 0;
savejson('',json, fnout);
end