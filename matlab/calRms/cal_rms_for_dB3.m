function rms=cal_rms_for_dB3(F1,F2,W1,W2)


% 当斜率为 -3
rms=(2.3*W1*F1*log10(F2/F1))^0.5;