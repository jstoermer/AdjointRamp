function out = jsonOrFilename(in)

if isstruct(in)
    out = in;
else
    out = loadjson(in);
end
end