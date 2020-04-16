%%%%% Use simulated ERPs to explore cluster statistics %%%%%%%%

%  The following code starts off with an ERP in two conditions, where it 
%  is slightly larger in condition 1 than 2. This simulation demonstrates 
%  a randomization test, correcting for multiple comparisons by using the 
%  largest cluster mass.

%  See this paper for more details
%  Maris E., Oostenveld R. "Nonparametric statistical testing of EEG and 
%  MEG-data." J Neurosci Methods. 2007 Apr 10;

%  http://www.fieldtriptoolbox.org/example/use_simulated_erps_to_explore_cluster_statistics/

%% create gaussian

tim = (0:1000)/1000;
erp = (1-cos(2*pi*tim))/2;
plot(tim, erp)
xlabel('time (s)')
ylabel('ERP (uV)')

%% create trials using gaussian and save into conditions as fieldtrip structs

data1 = []; %condition 1
for i=1:100
  data1.time{i} = tim;
  data1.trial{i}(1,:) = 1.1*erp + 0.1*randn(size(erp)); % the effect size is specified here
end
data1.label = {'Cz'};

data2 = []; %condition 2
for i=1:100
  data2.time{i} = tim;
  data2.trial{i}(1,:) = 1.0*erp + 0.1*randn(size(erp));
end
data2.label = {'Cz'};

%% create ERPs using ft_timelockanalysis

cfg = [];
cfg.keeptrials = 'yes';
timelock1 = ft_timelockanalysis(cfg, data1);
timelock2 = ft_timelockanalysis(cfg, data2);

figure %plot ERPs for both conditions
cfg = [];
ft_singleplotER(cfg, timelock1, timelock2);
legend({'condition 1', 'condition 2'})

%% Subtract the two ERPs (data1 - data2) then plot the difference

cfg = [];
cfg.operation = 'x1-x2';
cfg.parameter = 'avg';
difference = ft_math(cfg, timelock1, timelock2);

figure
cfg = [];
ft_singleplotER(cfg, difference);
legend({'difference'})

%% Run permutation statistics using Monte-Carlo estimates and correct for multiple comparisons using cluster method

cfg = [];
cfg.design = [ 1*ones(1,100) 2*ones(1,100) ];
cfg.ivar = 1;
cfg.method = 'montecarlo';
cfg.statistic = 'indepsamplesT';
cfg.correctm = 'cluster';
cfg.numrandomization = 2000;
% cfg.neighbours = []; % only cluster over time, not over channels
stat = ft_timelockstatistics(cfg, timelock1, timelock2);

%% Plot the difference curve and results from permutation statistics

figure
%t-values based on where observed values lie on null distribution
subplot(4,1,1); plot(stat.time, stat.stat); ylabel('t-value');
%observed values
subplot(4,1,2); plot(difference.time, difference.avg); ylabel('avg1-avg2 (uV)');
%actual p-values for significance
subplot(4,1,3); semilogy(stat.time, stat.prob); ylabel('prob'); axis([0 1 0.001 2])
%significant time points identified with a '1' if their p-values were low
%enough
subplot(4,1,4); plot(stat.time, stat.mask); ylabel('significant'); axis([0 1 -0.1 1.1])

%% Highlight where in the distributions the clusters were

%not sure on this, need to study the stats function more

figure
subplot(2,1,1); hist(stat.negdistribution, 200); axis([-10 10 0 100])
for i=1:numel(stat.negclusters)
  X = [stat.negclusters(i).clusterstat stat.negclusters(i).clusterstat];
  Y = [0 100];
  line(X, Y, 'color', 'r')
end

subplot(2,1,2); hist(stat.posdistribution, 200); axis([-10 10 0 100])

for i=1:numel(stat.posclusters)
  X = [stat.posclusters(i).clusterstat stat.posclusters(i).clusterstat];
  Y = [0 100];
  line(X, Y, 'color', 'r')
end