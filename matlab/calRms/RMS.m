function f=RMS(a)
n=length(a);
sum=0;
for i=1:n
    sum=sum+a(i)^2;  
end
f=sqrt(sum/n);