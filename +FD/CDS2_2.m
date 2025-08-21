function [ dvalddir ] = CDS2_2( dir, val )
%CDS2_2: 2nd order finite difference for second derivative

dir = dir(:); 
val = val(:);
n = length(dir);
dvalddir = zeros(n,1,'like',val);

% 2nd order forward difference
dvalddir(1) = ( 2 * val(1) - 5 * val(2) + 4 * val(3) - val(4) ) ./ (dir(2)-dir(1))^3;
% 2nd order central difference
dvalddir(2:n-1) = (val(3:end) - 2*val(2:end-1) + val(1:end-2))./ (dir(2:end-1)-dir(1:end-2)).^2; 
% 2nd order backward difference
dvalddir(n) = ( 2 * val(n) - 5 * val(n-1) + 4 * val(n-2) - val(n-3) ) ./ (dir(n)-dir(n-1))^3;

end