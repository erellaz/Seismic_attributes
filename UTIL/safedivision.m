function res= safedivision(num,denum,method)
%% Avoid divisions by 0 or very large values for denumerator getting close to 0
res1=sign(num)*sign(denum)*num^2/(denum^2+0.01);
if method==0
res=res1;
else
res=min(res1,4);
res=max(-4, res);
end

