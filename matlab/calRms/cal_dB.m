function dB=cal_dB(F1,F2,W1,W2)
dB=10*log10(W2/W1)/log2(F2/F1);