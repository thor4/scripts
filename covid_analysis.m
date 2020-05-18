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
% plot(pbCountydx.date,pbCountydx.newDeaths) %not helpful

figure(),clf %plot new cases on log-scale
plot(pbCountydx.date,pbCounty.cases,'LineWidth',4)
set(gca,'YScale','log','FontSize',20)
title('Total Cases in PB County','FontSize',24); ylabel('Cases'); 
export_fig new_cases.png -transparent % no background

% %setup percentages
% for i=7:length(pbCountydx.newCases)
%     pbCountydx.newCases7dayPercChg(i) = (pbCountydx.newCases(i)-...
%         pbCountydx.newCases(i-6))/pbCountydx.newCases(1)*100;
% end
% 
% %plot 7-day change number (not helpful)
% plot(pbCountydx.date,pbCountydx.newCases7dayPercChg,'LineWidth', 2)
% title('7-day Change'); ylabel('Percentage (%)'); 

%calc & plot 7-day moving avg of new cases
pbCountydx.newCasesMA = movmean(pbCountydx.newCases,7); 
figure(),clf %plot 7-day MA of new cases on log-scale
plot(pbCountydx.date,pbCountydx.newCasesMA,'LineWidth',4)
set(gca,'YScale','log','FontSize',20)
line([pbCountydx.date(56) pbCountydx.date(56)],...
    [1 max(pbCountydx.newCasesMA)],'LineStyle','--','Color',[0.25 0.25 0.25]);
text(pbCountydx.date(56)+0.5,75,'Easter payload?','FontSize',18);
title('7-day Moving Avg of New Cases in PBC','FontSize',24); ylabel('Cases'); 
export_fig 7_day_ma.png -transparent % no background





%nice plots: https://covid19chart.org/