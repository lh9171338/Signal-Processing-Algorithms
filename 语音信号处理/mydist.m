function dist = mydist(test,data)
%MYDIST - Compute the distance
%   
%   dist = mydist(test,data)

%% º∆À„≈∑ Ωæ‡¿Î
dist = vecnorm(data-test,2,2);
