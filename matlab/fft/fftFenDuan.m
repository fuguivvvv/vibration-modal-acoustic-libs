function [f,s] = fftFenDuan(x,fs,L)

fftAll=zeros(1,L);
index=1:L;
n=0;
while(index(end)<=length(x))
    p=x(index);
    %     k=1.852;
    %     x(index)=x(index).*hamming(L)'*k;
    
    %     k=2.381;
    %     x(index)=x(index).*blackman(L)'*k;
    %     k=4.6382;
%     k=4.638788014577959;  
     k=4.638788;  
    p=p.*flattopwin(L)'*k;
    
    fftAll=fftAll+2*abs(fft(p,L)/L);
    index=index+L;
    n=n+1;
end
s=fftAll/n;
s=s(1:L/2+1);
f=fs*(0:L/2)/L;
end

