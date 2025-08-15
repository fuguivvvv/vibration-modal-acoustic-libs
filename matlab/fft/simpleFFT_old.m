function [f,s] = simpleFFT(x,fs)

L=length(x);
%     k=1.852;
%     x(index)=x(index).*hamming(L)'*k;

%     k=2.381;
%     x(index)=x(index).*blackman(L)'*k;

%     k=4.6382;
%     k=4.638788014577959;

k=4.638788;
x=x.*flattopwin(L)'*k;
s=2*abs(fft(x,L)/L);
s=s(1:L/2+1);
f=fs*(0:L/2)/L;

end

