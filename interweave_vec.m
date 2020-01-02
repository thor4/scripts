%how to interweave two vectors (a & b) of equal length
a = [1 2 3]; b = [4 5 6];
c = zeros(1,2*numel(a)); %embedding vector
c(1:2:end) = a; c(2:2:end) = b;