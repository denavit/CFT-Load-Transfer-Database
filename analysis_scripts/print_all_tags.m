function print_all_tags()

fid = 1;
database_folder = '..';
databases = {
    'CCFT_Pushout_Tests'
    'RCFT_Pushout_Tests'};

% Find all tags used in the database
tags = cell(1,0);
for i = 1:length(databases)
    load(fullfile(database_folder,sprintf('%s.mat',databases{i})))
    for j = 1:length(data)
        for k = 1:length(data(j).Tags)
            if ~any(strcmp(tags,data(j).Tags{k}))
                tags = horzcat(tags,data(j).Tags{k});
            end
        end
    end
end
tags = unique(tags); % should already be unique, but this sorts them alphabetically too
tags = tags(~cellfun('isempty',tags));

% Print the tags
for i = 1:length(tags)
    fprintf(fid,'%s\n',tags{i});
end

end