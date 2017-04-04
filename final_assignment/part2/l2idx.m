function [out] = l2idx(strlist, el)
    for i=1:length(strlist)
        if contains(el, strlist{i})
            out = i;
            break;
        end
    end
end