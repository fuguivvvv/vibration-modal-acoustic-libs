function q=calDongYa(Ma,h)

index1=find(h<=11000);
index2=find(h>11000);
len=length(h);

q=zeros(1,len);
for i= 1:length(index1)
    q(index1(i))=0.5*1.2251*340.28^2*Ma(index1(i))^2*(1-2.2556/100000*h(index1(i)))^5.2561;
end

for i=1:length(index2)
    q(index2(i))=0.5*1.2251*295.06^2*Ma(index2(i))^2*0.2971*exp(1.73456-0.0001576873*h(index2(i)));
end

q=turn2ColVector(q);



