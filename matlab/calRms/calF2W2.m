function [F2,W2]=calF2W2(F1,W1,dB1,F3,W3,dB2)
%��һ�㣺W1,F1,��б��dB1
%�ڶ��㣺W2,F2,��б��dB2
%�����㣬W3,F3

A=[dB2/10,-1;dB1/10,-1];
Y=[dB2/10*log2(F3)-log10(W3);dB1/10*log2(F1)-log10(W1)];

X=A\Y;
F2=2^(X(1));
W2=10^(X(2));

