function [rmsData,rmst]=plotRMS(Data,time,delt_n)
% Data 数据
% time 时间序列
% delt_n 必须是偶数
%%
N=length(Data);
rmsData=zeros(floor(N/delt_n)-1,1);
rmst=zeros(floor(N/delt_n)-1,1);
nrms=0;
for i=1:delt_n:N-delt_n
    nrms=nrms+1;
  % rmsData(nrms)=RMS(Data(i:i+delt_n-1));
    rmsData(nrms)=calRMS_norm_n(Data(i:i+delt_n-1));
  
    rmst(nrms)=time(i+delt_n/2);     
end
%plot(rmst,rmsData);
%YLIM([0,20]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=RMS(a)

% rms = norm(x)/sqrt(n)

% f = norm(a)/sqrt(length(a));

n=length(a);
sum=0;
for i=1:n
    sum=sum+a(i)^2;  
end
f=sqrt(sum/n);