counties = readtable('us-counties.csv');
summary(counties) %give breakdown of table
counties.county = categorical(counties.county); %convert to categorical
% index rows with the correct variables in column
idx = counties.county == 'Palm Beach';
pbCounty = counties(idx,:); %create table based on index
pbCountydx = pbCounty; %setup diff table
for i=2:length(pbCountydx.cases) %find the differences per day
    pbCountydx{i,5} = pbCounty{i,5}-pbCounty{i-1,5};
    pbCountydx{i,6} = pbCounty{i,6}-pbCounty{i-1,6};
    pbCountydx.Properties.VariableNames{5} = 'newCases';
    pbCountydx.Properties.VariableNames{6} = 'newDeaths';
end
plot(pbCountydx.date,pbCountydx.newDeaths)
plot(pbCountydx.date,pbCountydx.newCases)

%nice plots: https://covid19chart.org/