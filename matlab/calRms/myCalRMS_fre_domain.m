function [rmsData,rmst]=myCalRMS_fre_domain(Data,time,delt_n,fre_range,fs,T0)
% 从时域计算rms
% Data 数据
% time 时间序列
% delt_n 必须是偶数
% T0，计算T0时刻的rms，时间宽度为delt_n
% delt_n必须是偶数
%%

% 计算所有时刻的 rms

if delt_n<fs
    nfft=delt_n;
else
nfft=fs;
end


x=Data;
t=time;
fre_start=fre_range(1);
fre_end=fre_range(2);

if nargin==5
    
    N=length(Data);
    rmsData=zeros(floor(N/delt_n)-1,1);
    rmst=zeros(floor(N/delt_n)-1,1);
    nrms=0;
    for i=1:delt_n:N-delt_n
        nrms=nrms+1;
    
        %         rmsData(nrms)=RMS(Data(i:i+delt_n-1));
        %         rmsData(nrms)=calRMS_norm_n(Data(i:i+delt_n-1));
        
        mypsd=classMyPSD(x,fs,nfft,t,t(i),t(i+delt_n-1),fre_start,fre_end);
        rmsData(nrms)=mypsd.rms;
        rmst(nrms)=time(i+delt_n/2);
    end
    %plot(rmst,rmsData);
    %YLIM([0,20]);    
    %计算 T0 时刻的 rms
elseif nargin==6
    minTemp=abs(time-T0);
    index=find(minTemp==min(minTemp));
    n_start=index(1)-(delt_n/2-1);
    n_end=index(1)+delt_n/2;
    rmst=time(index);        
    mypsd=classMyPSD(x,fs,nfft,t,t(n_start),t(n_end),fre_start,fre_end);
    rmsData=mypsd.rms;    
    
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