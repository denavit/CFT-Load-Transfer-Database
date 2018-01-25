function build_data(sectionType)

if nargin == 0
    build_data('CCFT')
    build_data('RCFT')
    return
end

% Units
dbUnits = 'US';
dbUnitSystem = unitSystem(dbUnits);

%% Read and Adjust Data
filename = sprintf('%s_Pushout_Tests.csv',sectionType);
[~,S] = csvread2(filename);
numData = length(S.Author);

data(numData) = struct;

% Trim whitespace from text fields
S.Author = strtrim(S.Author);
S.Specimen = strtrim(S.Specimen);

% Make sure things that are supposed to be cell arrays are cell arrays 
% even if they are blank
if isnumeric(S.Year)
    S.Year = cellfun(@int2str,num2cell(S.Year),'UniformOutput',false);
end
if isnumeric(S.Tags)
    S.Tags = cell(size(S.Tags));
end
if isnumeric(S.Notes)
    S.Notes = cell(size(S.Notes));
end


%% Interpret Data
for i = 1:numData
    
    try
        % General Information   
        data(i).Author      = S.Author{i};
        data(i).Year        = S.Year{i};
        data(i).Reference   = sprintf('%s %s',S.Author{i},S.Year{i});
        data(i).Specimen    = S.Specimen{i};
        %data(i).Tags        = S.Tags{i};
        data(i).Notes       = S.Notes{i};

        if isempty(S.Tags{i})
            data(i).Tags = cell(0,1);
        else
            C = textscan(S.Tags{i},'%s','Delimiter',',');
            data(i).Tags = C{1};
        end
        
        
        % Steel Strength
        data(i).Fy     = unitConvert('stress',S.Fy(i),S.Fy_units{i},dbUnitSystem);

        % Concrete Strength
        switch lower(S.fc_type{i})
            case {'cube','cube/100mm','cube/150mm','cube/200mm','cube/6in'}
                data(i).fc = 0.71*unitConvert('stress',S.fc(i),S.fc_units{i},dbUnitSystem);
            case {'','cylinder','cylinder/100mm','cylinder/150mm'}
                data(i).fc = unitConvert('stress',S.fc(i),S.fc_units{i},dbUnitSystem);
            otherwise
                error('Unknown fc type: %s',S.fc_type{i});
        end

        % Data Specific to Section Type
        switch sectionType
            case 'CCFT'
                data(i).D = unitConvert('length',S.D(i),S.D_units{i},dbUnitSystem);
                data(i).t = unitConvert('length',S.t(i),S.t_units{i},dbUnitSystem);

                section = CCFT(data(i).D,data(i).t,data(i).Fy,data(i).fc,dbUnits);
                data(i).p = section.interfacePerimeter;
                
            case 'RCFT'
                data(i).B = unitConvert('length',S.B(i),S.B_units{i},dbUnitSystem);
                data(i).H = unitConvert('length',S.H(i),S.H_units{i},dbUnitSystem);
                data(i).t = unitConvert('length',S.t(i),S.t_units{i},dbUnitSystem);
                data(i).SteelTubeType = S.SteelTubeType{i};

                section = RCFT(data(i).H,data(i).B,data(i).t,data(i).Fy,data(i).fc,dbUnits);
                if strcmpi(data(i).SteelTubeType,'WeldedBox')
                    section.ri = 0;
                end
                data(i).p = section.interfacePerimeter;
                
            otherwise
                error('Unknown section type %s',sectionType)
        end

        % Interface Length
        data(i).L = unitConvert('length',S.L(i),S.L_units{i},dbUnitSystem);

        % Strength Results
        data(i).Vmax = unitConvert( 'force',S.Vmax(i),S.Vmax_units{i},dbUnitSystem);
        if ~isnan(S.Fin(i))
            data(i).Fin = unitConvert('Stress',S.Fin(i),S.Fin_units{i},dbUnitSystem);
        elseif ~isnan(data(i).Vmax)
            data(i).Fin = data(i).Vmax / (data(i).p*data(i).L);
        else
            error('Bond stress not calculated');
        end        

    catch exception 
        fprintf('Error in building data for specicmen %i (%s)\n',i,sectionType);
        rethrow(exception);
    end
        
end

%% Save Data
save(sprintf('%s_Pushout_Tests.mat',sectionType),'data')
