function [rmsData,rmst]=cal_rms_time(Data,time,delt_n,T0)
% 从时域计算rms
% Data 数据
% time 时间序列
% delt_n 必须是偶数
% T0，计算T0时刻的rms，时间宽度为delt_n
%%
if nargin==3
    
    N=length(Data);
    rmsData=zeros(floor(N/delt_n)-1,1);
    rmst=zeros(floor(N/delt_n)-1,1);
    nrms=0;
    for i=1:delt_n:N-delt_n
        nrms=nrms+1;
%         rmsData(nrms)=RMS(Data(i:i+delt_n-1));
        rmsData(nrms)=calRMS_norm_n(Data(i:i+delt_n-1));
        
        rmst(nrms)=time(i+delt_n/2);
    end
    %plot(rmst,rmsData);
    %YLIM([0,20]);
elseif nargin==4
    minTemp=abs(time-T0);
    index=find(minTemp==min(minTemp));
    n_start=index(1)-(delt_n/2-1);
    n_end=index(1)+delt_n/2;
    rmst=time(index);
    rmsData=calRMS_norm_n(Data(n_start:n_end));
    
end



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