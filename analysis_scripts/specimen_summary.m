function specimen_summary

[UniqueRefs1,UniqueRefCount1,UniqueRefCountStr1,UniqueAlpha1] = getData('CCFT_Pushout_Tests');
[UniqueRefs2,UniqueRefCount2,UniqueRefCountStr2,UniqueAlpha2] = getData('RCFT_Pushout_Tests');

UniqueRefs          = horzcat(UniqueRefs1,UniqueRefs2);
UniqueRefCount      = horzcat(UniqueRefCount1,UniqueRefCount2);
UniqueRefCountStr   = horzcat(UniqueRefCountStr1,UniqueRefCountStr2);
UniqueAlpha         = horzcat(UniqueAlpha1,UniqueAlpha2);

[UUniqueRefs,ia,ic] = unique(UniqueRefs);
UUniqueAlpha = UniqueAlpha(ia);
UUniqueRefCount = nan(1,length(UUniqueRefs));
UUniqueRefCountStr = cell(1,length(UUniqueRefs));
for i = 1:length(UUniqueRefs)
    ind = find(ic==i);
    if numel(ind) == 1
        UUniqueRefCount(i) = UniqueRefCount(ind);
        UUniqueRefCountStr{i} = UniqueRefCountStr{ind};
    else
        UUniqueRefCount(i) = sum(UniqueRefCount(ind));
        temp = sprintf('%i Total:',UUniqueRefCount(i));
        for j = 1:length(ind)
            temp = sprintf('%s\n\t%s',temp,UniqueRefCountStr{ind(j)});
        end
        UUniqueRefCountStr{i} = temp;
    end
end


% Rearrange by year then name
[~,ix] = sort(UUniqueAlpha);
UUniqueRefs          = UUniqueRefs(ix);
UUniqueRefCount      = UUniqueRefCount(ix);
UUniqueRefCountStr   = UUniqueRefCountStr(ix);



% Print
for i = 1:length(UUniqueRefs)  
    fprintf('%s\t%s\n',UUniqueRefs{i},UUniqueRefCountStr{i});
end

end




function [UniqueRefs,UniqueRefCount,UniqueRefCountStr,UniqueAlpha] = getData(database)

database_folder = '..';
database_name = sprintf('%s.mat',database);
load(fullfile(database_folder,database_name))

numSpecimens = length(data);
Reference = cell(1,numSpecimens);
Alpha = cell(1,numSpecimens);

for i = 1:length(data)
    Reference{i} = sprintf('%s %s',data(i).Author,data(i).Year);
    Alpha{i}     = sprintf('%s %s',data(i).Year,data(i).Author);
end

% Find unique references and count
[UniqueRefs,ia,ic] = unique(Reference);
UniqueAlpha = Alpha(ia);
UniqueRefCount = nan(1,length(UniqueRefs));
UniqueRefCountStr = cell(1,length(UniqueRefs));
for i = 1:length(UniqueRefs)
    UniqueRefCount(i) = sum(ic==i);
    UniqueRefCountStr{i} = sprintf('%i %s',UniqueRefCount(i),database);
end

end