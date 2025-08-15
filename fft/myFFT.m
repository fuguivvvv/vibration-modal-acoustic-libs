function [f,s] = myFFT(x,fs,NFFT,t_start,t_end,NSegment)
%UNTITLED �˴���ʾ�йش˺�����ժҪ

%�ֶμ���fft

NAll=floor(length(x)/NSegment);
t=1/fs*(0:(length(x)-1));


if NAll<=0
    msgbox '�����LSegment����(̫����)�����ʵ�� ';
    return ;
end

%ָ��NFFT��Ĭ��overlap=0.5
index=find(t>=t_start & t<=t_end);
t=t(index);
x=x(index);
x=x-mean(x);

N=floor(NSegment/NFFT);%���ݳ�����NFFT�ı���

if N<1
    msgbox '����ʱ��LSegment̫�̻���NFFT̫�������ʵ��';
end

for iNAll=1:NAll
    fft_temp=zeros(NFFT,1);
    n_temp=0;
    for j=1:NFFT/2:((N-1)*NFFT+1)
        %                             ttt=2*abs(fft(obj.x(j:j+NFFT-1),NFFT)/NFFT);
        if j+NFFT-1<length(x)
            fft_temp=fft_temp+2*abs(fft(x(j:j+NFFT-1),NFFT)/NFFT);
            n_temp=n_temp+1;
        end
    end
    f{iNAll} = fs/2*linspace(0,1,NFFT/2+1);
    fftAll=fft_temp'/n_temp;%��ƽ��
    fftHalf=fftAll(1:length(linspace(0,1,NFFT/2+1)));
    s{iNAll}=fftHalf;
    
end

end

