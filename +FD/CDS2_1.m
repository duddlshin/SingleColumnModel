function [ dvalddir ] = CDS2_1( dir, val )
%CDS2_1: 2nd order finite difference for first derivative

dir = dir(:);           
val = val(:);   
n = length(dir);
dvalddir = zeros(n,1,'like',val);  

% 2nd order forward difference
dvalddir(1) = (-3 * val(1) + 4 * val(2) - val(3)) ./ (2 * (dir(2)-dir(1)));
% 2nd order central difference
dvalddir(2:n-1) = (val(3:end) - val(1:end-2))./(dir(3:end)-dir(1:end-2));     
% 2nd order backward difference
dvalddir(n) = (3 * val(n) - 4 * val(n-1) + val(n-2)) ./ (2 * (dir(n)-dir(n-1)));

end
