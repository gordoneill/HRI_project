function match = listsMatch(list1, list2)

list1s = sort(list1);
list2s = sort(list2);

match = 1;

if length(list1s) ~= length(list2s)
    match = 0;
else
    for entry = 1:length(list1s)
        if ~strcmp(list1s(entry), list2s(entry))
            match = 0;
        end
    end
end



