fs=8000;

t=1:1/fs:10;

f=30;
x=10*sin(2*pi*f*t);

% plot(t,x);

[f,s] = simpleFFT(x,fs);

loglog(f,s);

