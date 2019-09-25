% vector1 x x x ... x x x x
% vector2 x x x ... x x x x
% vector3 x x x ... x x x x
%         .................
% vectorN x x x ... x x x x
%   |
%   |
%   |
%   V
% result  a a a ... a a a a

function result = nan_aware_average(a)

result = zeros(1,size(a,2));

for i = 1:size(a,2)
    counter = 0;
    for j = 1:size(a,1)
        if(~isnan(a(j,i)))
            result(i) = result(i) + a(j,i);
            counter = counter+1;
        end
    end
    
    if(counter>0)
        result(i) = result(i) / counter;
    else
        result(i) = NaN;
    end
end

end