function [f,s] = simpleFFT(x,fs)
L=length(x);
if mod(L,2) >0
   L=L-1; 
end

k=4.638788014577959;
K=flattopwin(L)'*k;
S=x(1:L).*K;

Y = fft(S);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

s=P1;
f = fs*(0:(L/2))/L;

end

