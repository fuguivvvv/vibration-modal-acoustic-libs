function [f,s] = fftAvg(x,fs,L,flag)
%%%ע�⣺L�����ǲ����ʵ�������
%%%
%%% flag �Ƿ�Ӵ�
sizeX=size(x);
if sizeX(1)>1
   x=x'; 
end
fftAll=zeros(1,L/2+1);
index=1:L;
n=0;

N=floor(length(x)/L);

% disp(['in function fftAvg: N=' int2str(N)]);
% % error(['in function fftAvg: N=' int2str(N)]);
% warning(['in function fftAvg: N=' int2str(N)]);
k=4.638788014577959;

if nargin==4
    K=flattopwin(L)'*k;
    disp('�Ӵ�');
else
    K=1;
    disp('���Ӵ�');
end

if N<1
    msgbox 'L�������ݳ��ȣ�';
    return;
end

for i=1:N
    S=x(index).*K;
    Y = fft(S);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    fftAll=fftAll+P1;
    index=index+L;
end

fftAll=fftAll/N;
s=fftAll(1:L/2+1);
f = fs*(0:(L/2))/L;
end

