function W1=cal_W1(F1,F2,W2,dB)
W1=W2*10^(-1*dB/10*log2(F2/F1));
