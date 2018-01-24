function specimen_count()

fid = 1;
database_folder = '..';
databases = {
    'CCFT_Pushout_Tests'
    'RCFT_Pushout_Tests'};

% Count and print specimen totals
total = 0;
for i = 1:length(databases)
    load(fullfile(database_folder,sprintf('%s.mat',databases{i})));
    fprintf(fid,'%24s  %4i\n',databases{i},length(data));
    total = total + length(data);
end
fprintf(fid,'                   Total  %4i\n',total);

end