% adds the fields defined in defaults and their values to options, if they
% do not exist yet.
function options=incorporate_defaults(options,defaults)
flnames=fieldnames(defaults);
for i=1:length(flnames)
    name=flnames{i};
    if (~isfield(options,name))
        options=setfield(options,name,getfield(defaults,name));
    end
end
end