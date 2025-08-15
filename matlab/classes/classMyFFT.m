classdef classMyFFT< DataProcessBase
    
    properties
        x=0;
        t=0;
        t_start=0;
        t_end=0;
        
        
        %         fs=0;
        %         channelName='Ĭ��ͨ������';
        nfft=0;
        fre=0;
        Y=0;
        allDatalen=0;
        
        freMatrix={};
        YMatrix={};
        
        maxfre=[];
        maxY=[];
        maxT=[];
        
        NSegment;
        
        hPlotTime;
        hPlotFFT;
    end
    
    methods
        function obj=classMyFFT(x,t,fs,channelName,t_start,t_end,NFFT,NSegment)
            
            
            
            index=find(t>=t_start & t<=t_end);
            obj.t=t(index);
            obj.x=x(index);
            obj.x=obj.x-mean(obj.x);
            obj.fs=fs;
            obj.channelName=channelName;
            obj.allDatalen=length(x);
            
            switch nargin
                case 6
                
                case 7
                    obj.nfft=NFFT;
                    
                    [f,s] = fftAvg(obj.x,fs,NFFT,1);
                    obj.Y =s ;
                    obj.fre = f;
                    
                    
                case 8
                    obj.nfft=NFFT;
                    
                    if NSegment<NFFT
                        msgbox '����ʱ��̫�̻���NFFT̫�������ʵ��';
                        return;
                    end
                    
                    N=floor(length(obj.x)/NSegment);
                    index=1: NSegment;
                    i=0;
                    while index(end)<length(obj.x)
                        i=i+1;
                        
                        x=obj.x(index);
                        tic
                        [f,s] = fftAvg(x,fs,NFFT,1);
                        toc
                        
                        obj.YMatrix{i} =s ;
                        obj.freMatrix{i} = f;
                        
                        indexP=find(obj.freMatrix{i} >=10 & obj.freMatrix{i}<=2000 );
                        [psor,lsor] = findpeaks(obj.YMatrix{i}(indexP),obj.freMatrix{i}(indexP),...
                            'SortStr','descend','NPeaks' ,1,'MinPeakProminence',0,'MinPeakDistance',200);
                        obj.maxfre(i)=lsor;
                        obj.maxY(i)=psor;
                        obj.maxT(i)=obj.t(index(1))+1/fs*(NSegment/2);
                        index=index+NSegment;
                    end
                    
                otherwise
                    msgbox '����Ķ����ʼ�������������ԣ����ʵ�� ';
            end
        end
        
        function draw(obj)
            
            subplot(2,1,1);
            plot(obj.t,obj.x);
            set(gca,'XLim',[obj.t(1) obj.t(end)]);
            xlabel('ʱ��(s)');
            %             ylabel({'��' '��'  '��'  '(g)'},'Rotation',0,'VerticalAlignment','middle');
            ylabel('���ٶ�(g)');
            title(strcat(obj.channelName,'��ʱ������'));
            grid on;
            subplot(2,1,2);
            
            %                          loglog(obj.fre,obj.Y(1:obj.nfft/2+1));
            %             semilogx(obj.fre,obj.Y(1:obj.nfft/2+1));
            obj.hPlotFFT=plot(obj.fre,obj.Y);
            
%              obj.hPlotFFT=loglog(obj.fre,obj.Y);
            
            grid on;
            %             xlim([min(obj.fre) max(obj.fre)]);
            %             xlim([10 max(obj.fre)]);
            xlim([10 2000]);
            %             title([obj.channelName '���ٶ�Ƶ��']);
            title([obj.channelName '��Ƶ��']);
            xlabel('Ƶ�� (Hz)');
            %             ylabel('��ֵ��m/s)');
            ylabel('��ֵ');
            %             ylabel({'��' 'ֵ'  '��' '(m/s)'},'Rotation',0,'VerticalAlignment','middle');
            grid on ;
            
        end
        
        function drawMax(obj,ii)
            
            subplot(2,1,1);
            plot(obj.t,obj.x);
            set(gca,'XLim',[obj.t(1) obj.t(end)]);
            xlabel('ʱ��(s)');
            %             ylabel({'��' '��'  '��'  '(g)'},'Rotation',0,'VerticalAlignment','middle');
            ylabel('���ٶ�(g)');
            title(strcat(obj.channelName,'��ʱ������'));
            grid on;
            subplot(2,1,2);
            
            %                          loglog(obj.fre,obj.Y(1:obj.nfft/2+1));
            %             semilogx(obj.fre,obj.Y(1:obj.nfft/2+1));
            obj.hPlotFFT=plot(obj.freMatrix{ii},obj.YMatrix{ii});
            grid on;
            %             xlim([min(obj.fre) max(obj.fre)]);
            %             xlim([10 max(obj.fre)]);
            xlim([10 2000]);
            %             title([obj.channelName '���ٶ�Ƶ��']);
            title([obj.channelName '��Ƶ��']);
            xlabel('Ƶ�� (Hz)');
            %             ylabel('��ֵ��m/s)');
            ylabel('��ֵ');
            %             ylabel({'��' 'ֵ'  '��' '(m/s)'},'Rotation',0,'VerticalAlignment','middle');
            grid on ;
            
        end
        
        
        function drawVolocitySpectrum(obj)
            
            subplot(2,1,1);
            plot(obj.t,obj.x);
            set(gca,'XLim',[obj.t(1) obj.t(end)]);
            xlabel('ʱ��(s)');
            %             ylabel({'��' '��'  '��'  '(g)'},'Rotation',0,'VerticalAlignment','middle');
            ylabel('���ٶ�(g)');
            title(strcat(obj.channelName,'��ʱ������'));
            grid on;
            subplot(2,1,2);
            obj.Y=obj.Y*pi./(2*pi*obj.fre); %���ٶ���ת��Ϊ�ٶ���
            
            %   loglog(obj.fre,obj.Y);
            %   semilogx(obj.fre,obj.Y);
            obj.hPlotFFT=plot(obj.fre,obj.Y);
            grid on;
            %             xlim([min(obj.fre) max(obj.fre)]);
            
            
            %             xlim([10 max(obj.fre)]);
            xlim([10 2000]);
            title([obj.channelName '���ٶ�Ƶ��']);
            
            xlabel('Ƶ�� (Hz)');
            ylabel('��ֵ��m/s)');
            
            %             ylabel({'��' 'ֵ'  '��' '(m/s)'},'Rotation',0,'VerticalAlignment','middle');
            grid on ;
            
        end
        
        function calSimpleFFT(obj)
           [f,s] = simpleFFT(obj.x,obj.fs);
           
           obj.fre=f;
           obj.Y=s;
           
%            loglog(f,s);
%            
% %             title([obj.channelName '��Ƶ��']);
% %             xlabel('Ƶ�� (Hz)');
% %             
% %             ylabel('��ֵ');
            
        end
        
        
        
        function save(obj)
            if ~(strcmp(obj.channelName,'Ĭ��ͨ������'))
                fileName=['FFT&ʱ������ ' obj.channelName ' from ' num2str(obj.t(1)) 's to ' num2str(obj.t(end)) 's'];
                cd('./�������ļ���');
                %                 save([fileName '.mat'],'obj');
                %                 print(gcf,'-dmeta',[fileName '.emf']);
                saveas(gcf,[fileName '.fig'],'fig');
                cd ..
            else
                msgbox '��������ǰ�����ʼ��channelName ';
            end
            close all;
        end
        
        function [fre_out,Y_out]=findYofnearstFre(obj,fre)
            fre_tmep=obj.fre-fre;
            min_temp=min(abs(fre_tmep));
            index=find(abs(fre_tmep)==min_temp);
            Y_out=obj.Y(index);
            fre_out=obj.fre(index);
        end
        
        function calFFT(obj)
            L=obj.allDatalen;
            obj.Y = 2*abs(fft(obj.x)/L);
            obj.Y =obj.Y(1:length(linspace(0,1,L/2+1)));
            obj.fre = fs/2*linspace(0,1,L/2+1);
        end
        
    end
end

