function readDatabase(units)

if nargin < 1
    units = 'US';
end

ccft_database = 'CCFT_Pushout_Tests.csv';
rcft_database = 'RCFT_Pushout_Tests.csv';

us = unitSystem(units);

%% CCFT
[~,data] = csvread2(ccft_database);
numData = length(data.author);
CCFT(numData) = struct;
for i = 1:numData   
    CCFT(i).author      = data.author{i};
    CCFT(i).year        = data.year{i};
    CCFT(i).reference   = sprintf('%s %s',CCFT(i).author,CCFT(i).year);
    CCFT(i).specimen    = data.specimen{i};
    
    CCFT(i).L           = unitConvert('Length',data.L(i),data.L_units{i},us);
    CCFT(i).D           = unitConvert('Length',data.D(i),data.D_units{i},us);
    CCFT(i).t           = unitConvert('Length',data.t(i),data.t_units{i},us);
          
    CCFT(i).Fy          = unitConvert('Stress',data.Fy(i),data.Fy_units{i},us);
    CCFT(i).fc          = unitConvert('Stress',data.fc(i),data.fc_units{i},us);
    
    CCFT(i).Vmax        = unitConvert('Force',data.Vmax(i),data.Vmax_units{i},us);
    
    % Bond Stress
    if ~isnan(data.Fin(i))
        CCFT(i).Fin     = unitConvert('Stress',data.Fin(i),data.Fin_units{i},us);
    elseif ~isnan(CCFT(i).Vmax) 
        p = pi*(CCFT(i).D-2*CCFT(i).t);
        CCFT(i).Fin     = CCFT(i).Vmax / (p*CCFT(i).L);
    else
        error('Bond stress not calculated');        
    end
    
    % Tags
    if isempty(data.tags{i})
        CCFT(i).tags    = cell(0,1);
    else
        C = textscan(data.tags{i},'%s','Delimiter',';');
        CCFT(i).tags    = C{1};
    end
    CCFT(i).notes       = data.notes{i};
end



%% RCFT
[~,data] = csvread2(rcft_database);
numData = length(data.author);
RCFT(numData) = struct;
for i = 1:numData   
    RCFT(i).author      = data.author{i};
    RCFT(i).year        = data.year{i};
    RCFT(i).reference   = sprintf('%s %s',RCFT(i).author,RCFT(i).year);
    RCFT(i).specimen    = data.specimen{i};
    
    RCFT(i).L           = unitConvert('Length',data.L(i),data.L_units{i},us);
    RCFT(i).H           = unitConvert('Length',data.H(i),data.H_units{i},us);
    RCFT(i).B           = unitConvert('Length',data.B(i),data.B_units{i},us);
    RCFT(i).t           = unitConvert('Length',data.t(i),data.t_units{i},us);
            
    RCFT(i).Fy          = unitConvert('Stress',data.Fy(i),data.Fy_units{i},us);
    RCFT(i).fc          = unitConvert('Stress',data.fc(i),data.fc_units{i},us);
    
    RCFT(i).Vmax        = unitConvert('Force',data.Vmax(i),data.Vmax_units{i},us);
    
    % Bond Stress
    if ~isnan(data.Fin(i))
        RCFT(i).Fin     = unitConvert('Stress',data.Fin(i),data.Fin_units{i},us);
    elseif ~isnan(RCFT(i).Vmax)
        p = 2*(RCFT(i).H-2*RCFT(i).t) + 2*(RCFT(i).B-2*RCFT(i).t);
        RCFT(i).Fin     = RCFT(i).Vmax / (p*RCFT(i).L);
    else
        error('Bond stress not calculated');
    end
    
    % Tags
    if isempty(data.tags{i})
        RCFT(i).tags    = cell(0,1);
    else
        C = textscan(data.tags{i},'%s','Delimiter',';');
        RCFT(i).tags    = C{1};
    end
    RCFT(i).notes       = data.notes{i};
end

% cellfun(@(C)ismember('CyclicLoad',C),{CCFT(:).tags})

%% Save Database
save('database.mat','CCFT','RCFT')

end