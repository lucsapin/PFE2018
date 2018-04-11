function res = num22str(x,n)

if(x<0)
res = '-';
x = -x;
else
res = '';
end

e=floor(x);
res=[res int2str(e) 'p'];

e = x - e;

e = e * 10^n;

e = round(e);

a = e;
if(a~=0)
    while(a<10^(n-1))
        res=[res '0'];
        a = 10*a;
    end;
end;

res=[res int2str(e)];



