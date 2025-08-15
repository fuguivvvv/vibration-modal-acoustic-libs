classdef DataProcessPSD<DataProcessBase
    %untitled2 summary of this class goes here
    %   detailed explanation goes here
    
    properties
        
        %Ƶ�ʿ�ʼ
        startFrequencyForPSDCalculate=10;
        
        %Ƶ�ʽ���
        endFrequencyforPSDCalculate=2000;
        
        %����������Ƶ��
        conditionsFre=0;
        %�������� ��PSD
        conditionsPSD=0;
        %�������� ��rms
        conditionsRms=0;
        
        %��������Ƶ��
        PSDResultOfFrequency=0;
        %psd��������Ƶ������
        PSDResultData=0;
        
        
        %����ʱ��仯��rms��ʱ������
        timeOfRmsHis=0;
        %��������仯��rms
        rmsHis;
        %�ƶ�ʱ��ε�psd��rms
        rms=0;
        rmsArray=[];
        rms_time_domain=0;
        
        hTimsHisFigure=0;
        hPSDFigure=0;
        hSubplot=0
        
        %         hPlot=[];
        %         legends={};
        
        NFFT;
        %         NFFT=2048;
        
        delt_n_N=1;%rms�����Ĭ��1��
        
        removal_mean_s=0.5 %ȥ��ֵ��Ĭ��ȥǰ0.5sֵ�ľ�ֵ
        
        time_max=[];
        
        psd_max=[]
        psd_max_fre=[];
        
    end
    
    
    methods
        
        %%���캯��
        function obj=DataProcessPSD(fs,nfft,originalTime,originalData,channelName)
            obj=obj@DataProcessBase(fs,originalTime,originalData,channelName);
            obj.NFFT=nfft;
            
            obj.originalData=obj.originalData-mean(obj.originalData(1:obj.removal_mean_s*fs));
            obj.time_max=max(obj.originalData) ;
        end
        
        %����PSD
        function obj=calPSD(obj)
            if length(obj.dataForCalculate)>=1024
                nfft=obj.NFFT;
            else
                nfft=length(obj.dataForCalculate);
            end
            window=hanning(nfft);
            noverlap=0.5*nfft;
            
            
            x=obj.dataForCalculate-mean(obj.dataForCalculate(1:200));
            
            %             x=obj.dataForCalculate;
            
            [PSD,f]=pwelch(x,window,noverlap,nfft,obj.fs);
            
            
            ind_fre=find(f>= obj.startFrequencyForPSDCalculate & f<=obj.endFrequencyforPSDCalculate);
            f=f(ind_fre);
            PSD=PSD(ind_fre);
            
            %             obj.rms=calRMS_gongShi(f,PSD);
            obj.rms=sqrt(trapz(f,PSD));
            
            %             obj.rms=calRMS_interp(obj.f,obj.PSD);
            %                obj.rms=sqrt(trapz(obj.f,obj.PSD));
            
            
            obj.PSDResultOfFrequency=f;
            obj.PSDResultData=PSD;
            
            obj.rms_time_domain=rms(x); %������ֵ
            [obj.psd_max, index]=max(obj.PSDResultData);
            obj.psd_max_fre=f(index);
        end
        
        %����rms��ʱ���ϵ����ͼ
        function obj=calAndPlostRmsHis(obj,startTimeforCalculate,endTimeforCalculate)
            %             obj.hTimsHisFigure=figure;
            obj.startTimeforCalculate=startTimeforCalculate;
            obj.endTimeforCalculate=endTimeforCalculate;
            obj.setDataForCalculate(startTimeforCalculate,endTimeforCalculate);
            %           RMS�������� x ��
            %             ʱ�� ����rms��ȫƵ�Σ����˲�
            delt_n=obj.fs*obj.delt_n_N;
            [obj.rmsHis,obj.timeOfRmsHis]=myCalRMS(obj.dataForCalculate,obj.timeForCalculate,delt_n);
            
             obj.rmsHis=hampel(obj.rmsHis);
            
            plot(obj.timeOfRmsHis,obj.rmsHis);
            grid on;
            xlabel('ʱ�䣨s��');
            ylabel('�񶯼��ٶȾ�������g��');
            title(strcat('���ٶȾ�����ֵ-',obj.channelName));
        end
        
         function obj=PloTimeHis(obj,startTimeforCalculate,endTimeforCalculate)
            %             obj.hTimsHisFigure=figure;
            obj.startTimeforCalculate=startTimeforCalculate;
            obj.endTimeforCalculate=endTimeforCalculate;
            obj.setDataForCalculate(startTimeforCalculate,endTimeforCalculate);
                       
            plot(obj.timeForCalculate,obj.dataForCalculate);
            grid on;
            xlabel('ʱ�䣨s��');
            ylabel('�񶯼��ٶȣ�g��');
            title(strcat('ʱ������-',obj.channelName));
        end
        
        %����rms��ʱ���ϵ����ͼ,Ƶ�����rms
        function obj=calAndPlostRmsHis_fre_domain(obj,startTimeforCalculate,endTimeforCalculate,fre_range)
            %             obj.hTimsHisFigure=figure;
            obj.startTimeforCalculate=startTimeforCalculate;
            obj.endTimeforCalculate=endTimeforCalculate;
            obj.setDataForCalculate(startTimeforCalculate,endTimeforCalculate);
            %           RMS�������� x ��
            %             ʱ�� ����rms��ȫƵ�Σ����˲�
            delt_n=obj.fs*obj.delt_n_N;
            %             [obj.rmsHis,obj.timeOfRmsHis]=myCalRMS(obj.dataForCalculate,obj.timeForCalculate,delt_n);
            
            
            [obj.rmsHis,obj.timeOfRmsHis]=myCalRMS_fre_domain(obj.dataForCalculate,obj.timeForCalculate,delt_n,fre_range,obj.fs);
            
            plot(obj.timeOfRmsHis,obj.rmsHis);
            grid on;
            xlabel('ʱ�䣨s��');
            ylabel('�񶯼��ٶȾ�������g��');
            title(strcat('���ٶȾ�����ֵ-',obj.channelName));
        end
        
        
        
        % ����rms
        function obj=calRmsHis(obj,startTimeforCalculate,endTimeforCalculate,detlT)
            %             obj.hTimsHisFigure=figure;
            obj.startTimeforCalculate=startTimeforCalculate;
            obj.endTimeforCalculate=endTimeforCalculate;
            obj.setDataForCalculate(startTimeforCalculate,endTimeforCalculate);
            %           RMS�������� 2��
            delt_n=obj.fs*detlT;
            [obj.rmsHis,obj.timeOfRmsHis]=myCalRMS(obj.dataForCalculate,obj.timeForCalculate,delt_n);
            %             plot(obj.timeOfRmsHis,obj.rmsHis);
            %             grid on;
            %             xlabel('ʱ�䣨s��');
            %             ylabel('���ٶȣ�g��');
            %             title(strcat('���ٶȾ�����ֵ-',obj.channelName));
        end
        
        function obj=calRmsHis_fre_domain(obj,startTimeforCalculate,endTimeforCalculate,detlT)
            
            if nargin ==1
                
                
                
            elseif  nargin ==3
                
                obj.startTimeforCalculate=startTimeforCalculate;
                obj.endTimeforCalculate=endTimeforCalculate;
                obj.setDataForCalculate(startTimeforCalculate,endTimeforCalculate);
                %           RMS�������� 2��
                delt_n=obj.fs*detlT;
                
                [obj.rmsHis,obj.timeOfRmsHis]=myCalRMS(obj.dataForCalculate,obj.timeForCalculate,delt_n);
            end
            
        end
        %%���ü���PSD��Ƶ�ʷ�Χ
        function obj=setConditions(obj,conditionsFre,conditionsPSD)
            obj.conditionsFre=conditionsFre;
            obj.conditionsPSD=conditionsPSD;
        end
        
        %��PSDͼ
        function obj=PlotPSDOnly(obj)
%             obj.hPSDFigure=figure;
            obj.calPSD;
            obj.hPlot(end+1)=loglog(obj.PSDResultOfFrequency,obj.PSDResultData);
            obj.legends{end+1}=['Grms=',num2str(obj.rms,'%7.3f') 'g'];
            hold on;
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD,'LineWidth',1.3,'color','red');
            
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(-3/10),'LineWidth',1.3,'color','green');%����3dB����
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(3/10),'LineWidth',1.3,'color','green');
            
            set(gca,'XLim',[obj.startFrequencyForPSDCalculate obj.endFrequencyforPSDCalculate]);
            %                 set(gca,'YLim',[min(obj.PSD)*0.001 max([obj.PSD' obj.tiaoJian_PSD])*100]);
            
            set(gca,'YLim',[min(obj.PSDResultData)*0.001 max([obj.PSDResultData ; obj.conditionsPSD])*100]);
            
            
            xlabel('Ƶ��(Hz)');
            ylabel({'PSD'  '(g^2/Hz)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',6);
            title(strcat(obj.channelName,'-�������ܶ�'));
            
            grid on ;
            %                 if obj.class_nargin <12
            %             legend(['Grms=',num2str(obj.rms,'%7.3f') 'g'],'Location','NorthWest');
            
            
            %                 elseif obj.class_nargin==12
            %                     %                 legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�񶯻������� Grms=' num2str(obj.tiaoJian_rms) 'g'],'Location','NorthWest');
            %                     legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�������� Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],'Location','SouthWest');
            %                     %                 legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�������� Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],['��3dB����'],'Location','SouthWest'); %����3dB����
            %
            %
            %
            %                 end
            
            %             legend(strcat('���� Grms=',num2str(rms,'%7.3f')),['������ Grms=' num2str(tiaoJian_rms) 'g'],'Location','NorthWest');
            
            
        end
        
        %��ָ����hFigure�л���PSD��������С����λ��
        function obj=PlotPSDOnlyWithHFigure(obj,hFigure,exParam)
            % exParam��ʾ����С����λ��
            figure(hFigure);
            obj.hPlot(end+1)=loglog(obj.PSDResultOfFrequency,obj.PSDResultData);
            obj.legends{end+1}=['���� Grms=',num2str(obj.rms,'%7.3f') 'g,' 't=' num2str(exParam) 's'];
            
            hold on;
            set(gca,'XLim',[obj.startFrequencyForPSDCalculate obj.endFrequencyforPSDCalculate]);
            xlabel('Ƶ��(Hz)');
            ylabel({'PSD'  '(g^2/Hz)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',6);
            title(strcat(obj.channelName,'-�������ܶ�'));
            grid on ;
            %             legend(['Grms=',num2str(obj.rms,'%7.3f') 'g' 't=' num2str(exParam) 's'],'Location','NorthWest');
            
        end
        
        %���㲢 subplot ����PSD����ʱ������
        function obj=calAndPlotPSD(obj)
            calPSD(obj);
            obj.hSubplot=subplot(2,1,1);
            plot(obj.timeForCalculate,obj.dataForCalculate-mean(obj.dataForCalculate(1:200)));
            set(gca,'XLim',[obj.startTimeforCalculate obj.endTimeforCalculate]);
            xlabel('ʱ��(s)');
            ylabel({'��' '��'  '��' '(g)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',9);
            
            title([obj.channelName,'-ʱ������' '(' num2str(obj.startTimeforCalculate) 's to'  num2str(obj.endTimeforCalculate)  's)']);
            
            grid on;
            subplot(2,1,2);
            obj.hPlot(end+1)=loglog(obj.PSDResultOfFrequency,obj.PSDResultData);
            
            %for semilog
            %                         obj.hPlot(end+1)=semilogy(obj.PSDResultOfFrequency,obj.PSDResultData);
            
            hold on;
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD,'LineWidth',1.3,'color','red');
            
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(-3/10),'LineWidth',1.3,'color','green');%����3dB����
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(3/10),'LineWidth',1.3,'color','green');
            
            set(gca,'XLim',[obj.startFrequencyForPSDCalculate obj.endFrequencyforPSDCalculate]);
            
            set(gca,'YLim',[min(obj.PSDResultData)*0.001 max([obj.PSDResultData ;obj.conditionsPSD] )*100]);
            
            xlabel('Ƶ��(Hz)');
            ylabel({'PSD'  '(g^2/Hz)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',9);
            
            title([obj.channelName,'-�������ܶ�' '(' num2str(obj.startTimeforCalculate) 's to'  num2str(obj.endTimeforCalculate) 's)']);
            
            grid on ;
            %                 if obj.class_nargin <12
            %             legend(['Grms=',num2str(obj.rms,'%7.3f') 'g'],'Location','NorthWest');
            obj.legends{end+1}=['Grms=',num2str(obj.rms,'%7.3f') 'g'];
            
            
            
            %             obj.legends{end+1}=['������ Grms=' num2str(obj.conditionsRms) 'g'];
            
            
            
            %                 elseif obj.class_nargin==12
            %                     %                 legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�񶯻������� Grms=' num2str(obj.tiaoJian_rms) 'g'],'Location','NorthWest');
            %                     legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�������� Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],'Location','SouthWest');
            %                     %                 legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�������� Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],['��3dB����'],'Location','SouthWest'); %����3dB����
            %
            %
            %
            %                 end
            
            %             legend(strcat('���� Grms=',num2str(rms,'%7.3f')),['������ Grms=' num2str(tiaoJian_rms) 'g'],'Location','NorthWest');
            
            
        end
        
        % ��ʵ�����PSD
        function obj=calRmsFromFrequencyDomian(obj)
            %             obj.rms=calRMS_gongShi(obj.PSDResultOfFrequency,obj.PSDResultData);
            
            %                         obj.rms=calRMS_interp(obj.PSDResultOfFrequency,obj.PSDResultData);
            obj.rms=calRms_f(obj.PSDResultOfFrequency,obj.PSDResultData);
            
        end
        
        % ���㻷��������rms
        function obj=calRmsForConditions(obj)
            %             obj.conditionsRms=calRMS_gongShi(obj.conditionsFre,obj.conditionsPSD);
            
            obj.conditionsRms=calRMS_interp(obj.conditionsFre,obj.conditionsPSD);
        end
        
        %�滷������
        function obj=plotCondition(obj,legendName,colorDefine)
            %             subplot(obj.hSubplot);
            %             subplot(2,1,2);
            %             obj.hPlot(end+1)=loglog(obj.conditionsFre,obj.conditionsPSD,'LineWidth',2,'color','red');
            
            
            %%ok
            %             obj.hPlot(end+1)=loglog(obj.conditionsFre,obj.conditionsPSD,'LineWidth',2);
            %             obj.legends{end+1}=['������ Grms=' num2str(obj.conditionsRms) 'g'];
            
            %%
            
            
            switch nargin
                case 1
                    obj.hPlot(end+1)=loglog(obj.conditionsFre,obj.conditionsPSD,'LineWidth',2);
                    obj.legends{end+1}=['������ Grms=' num2str(obj.conditionsRms,'%-7.3f') 'g'];
                case 2
                    obj.hPlot(end+1)=loglog(obj.conditionsFre,obj.conditionsPSD,'LineWidth',2,'color','red');
                    obj.legends{end+1}=legendName;
                case 3
                    obj.hPlot(end+1)=loglog(obj.conditionsFre,obj.conditionsPSD,'LineWidth',2,'color',colorDefine);
                    obj.legends{end+1}=legendName;
                otherwise
                    disp('plotCondition ������������')
            end
            
            
            
            
            %             loglog(obj.conditionsFre,obj.conditionsPSD*10^(-3/10),'LineWidth',1.3,'color','green');%����3dB����
            %             loglog(obj.conditionsFre,obj.conditionsPSD*10^(3/10),'LineWidth',1.3,'color','green');
            
            %             legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�񶯻������� Grms=' num2str(obj.conditionsRms) 'g'],'Location','NorthWest');
            %             legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�������� Grms=' num2str(obj.conditionsRms,'%7.2f') 'g'],'Location','SouthWest');
            %             legend(['���� Grms=',num2str(obj.rms,'%7.3f') 'g'],['�������� Grms=' num2str(obj.conditionsRms,'%7.2f') 'g'],['��3dB����'],'Location','SouthWest'); %����3dB����           %
            %
            %
            %             legend(strcat('���� Grms=',num2str(rms,'%7.3f')),['������ Grms=' num2str(tiaoJian_rms) 'g'],'Location','NorthWest');
            
            
        end
        
        %����ͼ��� lengend
        function obj=lengendAll(obj,location)
            hL=legend(obj.hPlot(:),obj.legends{:},'Location',location);
            %             set(hL,'FontSize',0.01);
            %                         legend(obj.legends{:},'Location','NorthWest','FontSize','1');
            
        end
        
        %         function obj=save(obj)
        %             declareGlobalVars;
        %             saveas(gcf,[globalResultsPath '\psd' obj.channelName],'fig');
        %             saveas(gcf,[globalResultsPath '\psd' obj.channelName],'emf');
        %
        %             %             print(gcf,'-dmeta',[globalResultsPath '\psd' obj.channelName '.emf']);
        %         end
        
        %����ʱ������
        function obj=plotTimeHistory(obj)
            drawVibrationTimeHis(obj.timeForCalculate,obj.dataForCalculate,obj.channelName);
        end
    end
    
end
