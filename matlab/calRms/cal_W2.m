function W2=cal_W2(F1,F2,W1,dB)
W2=W1*10^(log2(F2/F1)*dB/10);
