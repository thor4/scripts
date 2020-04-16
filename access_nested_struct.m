% use this script to access fields in nested struct elements, note the 
% second for-loop

% load('mGoodStableRule1PingRej-split_by_BehResp_and_Area.mat')

%Use ‘fieldnames’ to retrieve the names of all fields at one level of the structure.

fn = fieldnames(monkey);
for lp=1:length(fn)
doSomeOperation( mystruct.( fn{lp} ) );
end

%I've become more comfortable just using the field names as the loop arguments outright.

fn = fieldnames(mystruct); %make sure this is a 1x# vector ie: 1x2 vs 2x1
for lp=fn
doSomeOperation( mystruct( lp{:} ) );
end