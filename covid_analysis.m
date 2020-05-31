%% Read-in and build-out data structures

casesPBC = readtable('us-counties.csv');
summary(casesPBC) %give breakdown of table
casesPBC.county = categorical(casesPBC.county); %convert to categorical
% index rows with the correct variables in column
idx = casesPBC.county == 'Palm Beach';
pbCounty = casesPBC(idx,:); %create table based on index
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

%% 05/19/20 Analysis

% T-test on new cases per day

%Step 1: plot the latest 7-day MA with data through 5/19
%calc & plot 7-day moving avg of new cases
pbCountydx.newCasesMA = movmean(pbCountydx.newCases,7); 
figure(),clf %plot 7-day MA of new cases on log-scale
plot(pbCountydx.date,pbCountydx.newCasesMA,'LineWidth',4)
set(gca,'YScale','log','FontSize',20)
%April 1 is when the exponential growth appears to end
expEnd = find(pbCountydx.date=='2020-04-01'); %21
line([pbCountydx.date(expEnd) pbCountydx.date(expEnd)],...
    [1 max(pbCountydx.newCasesMA)],'LineStyle','--','Color',[0.25 0.25 0.25]);
text(pbCountydx.date(expEnd)+0.5,65,'Flat curve / end of exponential growth','FontSize',18);
title('7-day Moving Avg of New Cases in Palm Beach County','FontSize',24); ylabel('Cases'); 
export_fig 7_day_ma_051920.png -transparent % no background

%Step 2: Plot the latest flat-curve portion of 7-day MA
figure(),clf %zoom in on Apr1-present for 7-day MA new cases log-scale
plot(pbCountydx.date(expEnd:end),pbCountydx.newCasesMA(expEnd:end),'LineWidth',4)
set(gca,'YScale','log','FontSize',20)
earlyCovx2 = find(pbCountydx.date(expEnd:end)=='2020-04-20')-1; %19
earlyCovx = [0 earlyCovx2 earlyCovx2 0]; ys = ylim; earlyCovy = [ys(1) ys(1) ys(2) ys(2)];
early = patch(earlyCovx,earlyCovy,'red'); alpha(early,0.25);
lateCovx1 = find(pbCountydx.date(expEnd:end)=='2020-05-06')-1; %35
lateCovx2 = length(pbCountydx.date(expEnd:end))-1; %47
lateCovx = [lateCovx1 lateCovx2 lateCovx2 lateCovx1]; ys = ylim; 
lateCovy = [ys(1) ys(1) ys(2) ys(2)];
late = patch(lateCovx,lateCovy,'green'); alpha(late,0.25);
text(5,65,'Early Regime','FontSize',18); text(37,65,'Late Regime','FontSize',18);
title('7-day Moving Avg of New Cases in Palm Beach County','FontSize',24); 
ylabel('Cases'); 
export_fig 7_day_ma_regimes-051920.png -transparent % no background

%calculate total data points in early regime then late regime
early_total = length(pbCountydx.date(expEnd:expEnd+earlyCovx2)); %20
late_total = length(pbCountydx.date(expEnd+lateCovx1:end)); %13


figure(),clf %plot the new cases per day from each regime
plot(pbCountydx.date(expEnd:end),pbCountydx.newCases(expEnd:end),'LineWidth',4)
set(gca,'YScale','log','FontSize',20)
ys = ylim; earlyCovy = [ys(1) ys(1) ys(2) ys(2)]; %update ylims new plot
early = patch(earlyCovx,earlyCovy,'red'); alpha(early,0.25);
lateCovy = [ys(1) ys(1) ys(2) ys(2)];
late = patch(lateCovx,lateCovy,'green'); alpha(late,0.25);
text(5,15,'Early Regime','FontSize',18); text(37,15,'Late Regime','FontSize',18);
title('Daily New Cases in Palm Beach County','FontSize',24); 
ylabel('Cases');
export_fig daily_new_cases_regimes-051920.png -transparent % no background


%run the same t-test, but this time on the new cases each day, not the
%moving average
earlyCov = pbCountydx.newCases(expEnd:expEnd+earlyCovx2); %April 1 - 20
lateCov = pbCountydx.newCases(expEnd+lateCovx1:end); %May6 - May 18
disp(mean(earlyCov)),disp(mean(lateCov)) %85.35, 97.5385
%test the alt hypothesis that the pop mean of lateCov > pop mean of earlyCov
[h,p,ci,stats] = ttest2(earlyCov,lateCov,'tail','left') 
% p = 0.2405, tstat: -0.7132, df: 31 *not significant*

%% 05/31/20 Analysis

casesPBC = readtable('Florida_COVID19_Case_Line_Data.csv');
%convert var's of interest to categorical
casesPBC.Age_group = categorical(casesPBC.Age_group); 
casesPBC.Gender = categorical(casesPBC.Gender); 
casesPBC.Hospitalized = categorical(casesPBC.Hospitalized); 
casesPBC.Died = categorical(casesPBC.Died); 
casesPBC.EventDate = datetime(casesPBC.EventDate,...
    'InputFormat','yyyy/MM/dd HH:mm:ss+ss'); %convert to date type

casesPBC.EventDate = datetime(casesPBC.EventDate,...
    'InputFormat','yyyy/MM/dd'); %convert to date type

%convert the table to a timetable
casesPBCtt = table2timetable(casesPBC,'RowTimes','EventDate');
casesPBCtt(1:5,:)
summary(casesPBCtt) %give breakdown of table

%how to summarize each day's columns?
% https://www.mathworks.com/help/matlab/matlab_prog/subscript-into-times-of-timetable.html

%create additional views for plotting
idx = casesPBC.Hospitalized == 'YES';
hospsPBCtt = casesPBCtt(idx,:); %create table based on index (1197 total)

pbCountydx = pbCounty; %setup diff table
for i=2:length(pbCountydx.cases) %find the differences per day
    pbCountydx{i,5} = pbCounty{i,5}-pbCounty{i-1,5};
    pbCountydx{i,6} = pbCounty{i,6}-pbCounty{i-1,6};
    pbCountydx.Properties.VariableNames{5} = 'newCases';
    pbCountydx.Properties.VariableNames{6} = 'newDeaths';
end



%nice plots: https://covid19chart.org/