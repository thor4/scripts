%% Read-in and build-out data structures

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


%% 05/17/20 Analysis

figure(),clf %plot new cases on log-scale
plot(pbCountydx.date,pbCounty.cases,'LineWidth',4)
set(gca,'YScale','log','FontSize',20)
title('Total Cases in PB County','FontSize',24); ylabel('Cases'); 
export_fig new_cases.png -transparent % no background

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

%% 05/18/20 Analysis

%calc & plot 7-day moving avg of new cases
pbCountydx.newCasesMA = movmean(pbCountydx.newCases,7); 
figure(),clf %plot 7-day MA of new cases on log-scale
plot(pbCountydx.date,pbCountydx.newCasesMA,'LineWidth',4)
set(gca,'YScale','log','FontSize',20)
%April 1 is when the exponential growth appears to end
expEnd = find(pbCountydx.date=='2020-04-01'); %20
line([pbCountydx.date(expEnd) pbCountydx.date(expEnd)],...
    [1 max(pbCountydx.newCasesMA)],'LineStyle','--','Color',[0.25 0.25 0.25]);
text(pbCountydx.date(expEnd)+0.5,65,'Flat curve / end of exponential growth','FontSize',18);
title('7-day Moving Avg of New Cases in Palm Beach County','FontSize',24); ylabel('Cases'); 
export_fig 7_day_ma_051820.png -transparent % no background


figure(),clf %zoom in on Apr1-present for 7-day MA new cases log-scale
plot(pbCountydx.date(expEnd:end),pbCountydx.newCasesMA(expEnd:end),'LineWidth',4)
set(gca,'YScale','log','FontSize',20)
earlyCovx2 = find(pbCountydx.date(expEnd:end)=='2020-04-20')-1; %19
earlyCovx = [0 earlyCovx2 earlyCovx2 0]; ys = ylim; earlyCovy = [ys(1) ys(1) ys(2) ys(2)];
early = patch(earlyCovx,earlyCovy,'red'); alpha(early,0.25);
lateCovx1 = find(pbCountydx.date(expEnd:end)=='2020-05-06')-1; %35
lateCovx2 = length(pbCountydx.date(expEnd:end))-1; %45
lateCovx = [lateCovx1 lateCovx2 lateCovx2 lateCovx1]; ys = ylim; 
lateCovy = [ys(1) ys(1) ys(2) ys(2)];
late = patch(lateCovx,lateCovy,'green'); alpha(late,0.25);
text(5,65,'Early Regime','FontSize',18); text(37,65,'Late Regime','FontSize',18);
title('7-day Moving Avg of New Cases in Palm Beach County','FontSize',24); 
ylabel('Cases'); 
export_fig 7_day_ma_regimes-051820.png -transparent % no background

earlyCov = pbCountydx.newCasesMA(expEnd:expEnd+earlyCovx2); %April 1 - 20
lateCov = pbCountydx.newCasesMA(expEnd+lateCovx1:end); %May6 - May 17
%test the alt hypothesis that the pop mean of lateCov > pop mean of earlyCov
[h,p,ci,stats] = ttest2(earlyCov,lateCov,'tail','left') 
% p = 7.6726e-05, tstat: -4.3292, df: 30


%nice plots: https://covid19chart.org/