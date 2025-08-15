function F1=cal_F1(F2,W1,W2,dB)
F1=F2/2^(10/dB*log10(W2/W1));
