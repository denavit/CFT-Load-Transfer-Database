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
    if isnumeric(data(1).Tags)
        continue
    end
    tags = horzcat(tags,unique({data(:).Tags}));
end
tags = unique(tags);
tags = tags(~cellfun('isempty',tags));

% Print the tags
for i = 1:length(tags)
    fprintf(fid,'%s\n',tags{i});
end

end