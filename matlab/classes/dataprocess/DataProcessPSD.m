classdef DataProcessPSD<DataProcessBase
    %untitled2 summary of this class goes here
    %   detailed explanation goes here
    
    properties
        
        %频率开始
        startFrequencyForPSDCalculate=10;
        
        %频率结束
        endFrequencyforPSDCalculate=2000;
        
        %环境条件，频率
        conditionsFre=0;
        %环境条件 ，PSD
        conditionsPSD=0;
        %环境条件 ，rms
        conditionsRms=0;
        
        %计算结果，频率
        PSDResultOfFrequency=0;
        %psd计算结果，频率数据
        PSDResultData=0;
        
        
        %随着时间变化的rms的时间序列
        timeOfRmsHis=0;
        %随着随机变化的rms
        rmsHis;
        %制定时间段的psd的rms
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
        
        delt_n_N=1;%rms间隔，默认1秒
        
        removal_mean_s=0.5 %去均值，默认去前0.5s值的均值
        
        time_max=[];
        
        psd_max=[]
        psd_max_fre=[];
        
    end
    
    
    methods
        
        %%构造函数
        function obj=DataProcessPSD(fs,nfft,originalTime,originalData,channelName)
            obj=obj@DataProcessBase(fs,originalTime,originalData,channelName);
            obj.NFFT=nfft;
            
            obj.originalData=obj.originalData-mean(obj.originalData(1:obj.removal_mean_s*fs));
            obj.time_max=max(obj.originalData) ;
        end
        
        %计算PSD
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
            
            obj.rms_time_domain=rms(x); %均方根值
            [obj.psd_max, index]=max(obj.PSDResultData);
            obj.psd_max_fre=f(index);
        end
        
        %计算rms与时间关系并绘图
        function obj=calAndPlostRmsHis(obj,startTimeforCalculate,endTimeforCalculate)
            %             obj.hTimsHisFigure=figure;
            obj.startTimeforCalculate=startTimeforCalculate;
            obj.endTimeforCalculate=endTimeforCalculate;
            obj.setDataForCalculate(startTimeforCalculate,endTimeforCalculate);
            %           RMS计算间隔是 x 秒
            %             时域 计算rms，全频段，不滤波
            delt_n=obj.fs*obj.delt_n_N;
            [obj.rmsHis,obj.timeOfRmsHis]=myCalRMS(obj.dataForCalculate,obj.timeForCalculate,delt_n);
            
             obj.rmsHis=hampel(obj.rmsHis);
            
            plot(obj.timeOfRmsHis,obj.rmsHis);
            grid on;
            xlabel('时间（s）');
            ylabel('振动加速度均方根（g）');
            title(strcat('加速度均方根值-',obj.channelName));
        end
        
         function obj=PloTimeHis(obj,startTimeforCalculate,endTimeforCalculate)
            %             obj.hTimsHisFigure=figure;
            obj.startTimeforCalculate=startTimeforCalculate;
            obj.endTimeforCalculate=endTimeforCalculate;
            obj.setDataForCalculate(startTimeforCalculate,endTimeforCalculate);
                       
            plot(obj.timeForCalculate,obj.dataForCalculate);
            grid on;
            xlabel('时间（s）');
            ylabel('振动加速度（g）');
            title(strcat('时域曲线-',obj.channelName));
        end
        
        %计算rms与时间关系并绘图,频域计算rms
        function obj=calAndPlostRmsHis_fre_domain(obj,startTimeforCalculate,endTimeforCalculate,fre_range)
            %             obj.hTimsHisFigure=figure;
            obj.startTimeforCalculate=startTimeforCalculate;
            obj.endTimeforCalculate=endTimeforCalculate;
            obj.setDataForCalculate(startTimeforCalculate,endTimeforCalculate);
            %           RMS计算间隔是 x 秒
            %             时域 计算rms，全频段，不滤波
            delt_n=obj.fs*obj.delt_n_N;
            %             [obj.rmsHis,obj.timeOfRmsHis]=myCalRMS(obj.dataForCalculate,obj.timeForCalculate,delt_n);
            
            
            [obj.rmsHis,obj.timeOfRmsHis]=myCalRMS_fre_domain(obj.dataForCalculate,obj.timeForCalculate,delt_n,fre_range,obj.fs);
            
            plot(obj.timeOfRmsHis,obj.rmsHis);
            grid on;
            xlabel('时间（s）');
            ylabel('振动加速度均方根（g）');
            title(strcat('加速度均方根值-',obj.channelName));
        end
        
        
        
        % 计算rms
        function obj=calRmsHis(obj,startTimeforCalculate,endTimeforCalculate,detlT)
            %             obj.hTimsHisFigure=figure;
            obj.startTimeforCalculate=startTimeforCalculate;
            obj.endTimeforCalculate=endTimeforCalculate;
            obj.setDataForCalculate(startTimeforCalculate,endTimeforCalculate);
            %           RMS计算间隔是 2秒
            delt_n=obj.fs*detlT;
            [obj.rmsHis,obj.timeOfRmsHis]=myCalRMS(obj.dataForCalculate,obj.timeForCalculate,delt_n);
            %             plot(obj.timeOfRmsHis,obj.rmsHis);
            %             grid on;
            %             xlabel('时间（s）');
            %             ylabel('加速度（g）');
            %             title(strcat('加速度均方根值-',obj.channelName));
        end
        
        function obj=calRmsHis_fre_domain(obj,startTimeforCalculate,endTimeforCalculate,detlT)
            
            if nargin ==1
                
                
                
            elseif  nargin ==3
                
                obj.startTimeforCalculate=startTimeforCalculate;
                obj.endTimeforCalculate=endTimeforCalculate;
                obj.setDataForCalculate(startTimeforCalculate,endTimeforCalculate);
                %           RMS计算间隔是 2秒
                delt_n=obj.fs*detlT;
                
                [obj.rmsHis,obj.timeOfRmsHis]=myCalRMS(obj.dataForCalculate,obj.timeForCalculate,delt_n);
            end
            
        end
        %%配置计算PSD的频率范围
        function obj=setConditions(obj,conditionsFre,conditionsPSD)
            obj.conditionsFre=conditionsFre;
            obj.conditionsPSD=conditionsPSD;
        end
        
        %绘PSD图
        function obj=PlotPSDOnly(obj)
%             obj.hPSDFigure=figure;
            obj.calPSD;
            obj.hPlot(end+1)=loglog(obj.PSDResultOfFrequency,obj.PSDResultData);
            obj.legends{end+1}=['Grms=',num2str(obj.rms,'%7.3f') 'g'];
            hold on;
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD,'LineWidth',1.3,'color','red');
            
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(-3/10),'LineWidth',1.3,'color','green');%带±3dB条件
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(3/10),'LineWidth',1.3,'color','green');
            
            set(gca,'XLim',[obj.startFrequencyForPSDCalculate obj.endFrequencyforPSDCalculate]);
            %                 set(gca,'YLim',[min(obj.PSD)*0.001 max([obj.PSD' obj.tiaoJian_PSD])*100]);
            
            set(gca,'YLim',[min(obj.PSDResultData)*0.001 max([obj.PSDResultData ; obj.conditionsPSD])*100]);
            
            
            xlabel('频率(Hz)');
            ylabel({'PSD'  '(g^2/Hz)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',6);
            title(strcat(obj.channelName,'-功率谱密度'));
            
            grid on ;
            %                 if obj.class_nargin <12
            %             legend(['Grms=',num2str(obj.rms,'%7.3f') 'g'],'Location','NorthWest');
            
            
            %                 elseif obj.class_nargin==12
            %                     %                 legend(['试验 Grms=',num2str(obj.rms,'%7.3f') 'g'],['振动环境条件 Grms=' num2str(obj.tiaoJian_rms) 'g'],'Location','NorthWest');
            %                     legend(['试验 Grms=',num2str(obj.rms,'%7.3f') 'g'],['环境条件 Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],'Location','SouthWest');
            %                     %                 legend(['试验 Grms=',num2str(obj.rms,'%7.3f') 'g'],['环境条件 Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],['±3dB条件'],'Location','SouthWest'); %带±3dB条件
            %
            %
            %
            %                 end
            
            %             legend(strcat('试验 Grms=',num2str(rms,'%7.3f')),['振动条件 Grms=' num2str(tiaoJian_rms) 'g'],'Location','NorthWest');
            
            
        end
        
        %在指定的hFigure中绘制PSD，可配置小数点位数
        function obj=PlotPSDOnlyWithHFigure(obj,hFigure,exParam)
            % exParam表示保留小数点位数
            figure(hFigure);
            obj.hPlot(end+1)=loglog(obj.PSDResultOfFrequency,obj.PSDResultData);
            obj.legends{end+1}=['试验 Grms=',num2str(obj.rms,'%7.3f') 'g,' 't=' num2str(exParam) 's'];
            
            hold on;
            set(gca,'XLim',[obj.startFrequencyForPSDCalculate obj.endFrequencyforPSDCalculate]);
            xlabel('频率(Hz)');
            ylabel({'PSD'  '(g^2/Hz)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',6);
            title(strcat(obj.channelName,'-功率谱密度'));
            grid on ;
            %             legend(['Grms=',num2str(obj.rms,'%7.3f') 'g' 't=' num2str(exParam) 's'],'Location','NorthWest');
            
        end
        
        %计算并 subplot 绘制PSD，带时域曲线
        function obj=calAndPlotPSD(obj)
            calPSD(obj);
            obj.hSubplot=subplot(2,1,1);
            plot(obj.timeForCalculate,obj.dataForCalculate-mean(obj.dataForCalculate(1:200)));
            set(gca,'XLim',[obj.startTimeforCalculate obj.endTimeforCalculate]);
            xlabel('时间(s)');
            ylabel({'加' '速'  '度' '(g)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',9);
            
            title([obj.channelName,'-时域曲线' '(' num2str(obj.startTimeforCalculate) 's to'  num2str(obj.endTimeforCalculate)  's)']);
            
            grid on;
            subplot(2,1,2);
            obj.hPlot(end+1)=loglog(obj.PSDResultOfFrequency,obj.PSDResultData);
            
            %for semilog
            %                         obj.hPlot(end+1)=semilogy(obj.PSDResultOfFrequency,obj.PSDResultData);
            
            hold on;
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD,'LineWidth',1.3,'color','red');
            
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(-3/10),'LineWidth',1.3,'color','green');%带±3dB条件
            %             loglog(obj.tiaoJian_fre,obj.tiaoJian_PSD*10^(3/10),'LineWidth',1.3,'color','green');
            
            set(gca,'XLim',[obj.startFrequencyForPSDCalculate obj.endFrequencyforPSDCalculate]);
            
            set(gca,'YLim',[min(obj.PSDResultData)*0.001 max([obj.PSDResultData ;obj.conditionsPSD] )*100]);
            
            xlabel('频率(Hz)');
            ylabel({'PSD'  '(g^2/Hz)'},'Rotation',0,'VerticalAlignment','middle','Fontsize',9);
            
            title([obj.channelName,'-功率谱密度' '(' num2str(obj.startTimeforCalculate) 's to'  num2str(obj.endTimeforCalculate) 's)']);
            
            grid on ;
            %                 if obj.class_nargin <12
            %             legend(['Grms=',num2str(obj.rms,'%7.3f') 'g'],'Location','NorthWest');
            obj.legends{end+1}=['Grms=',num2str(obj.rms,'%7.3f') 'g'];
            
            
            
            %             obj.legends{end+1}=['振动条件 Grms=' num2str(obj.conditionsRms) 'g'];
            
            
            
            %                 elseif obj.class_nargin==12
            %                     %                 legend(['试验 Grms=',num2str(obj.rms,'%7.3f') 'g'],['振动环境条件 Grms=' num2str(obj.tiaoJian_rms) 'g'],'Location','NorthWest');
            %                     legend(['试验 Grms=',num2str(obj.rms,'%7.3f') 'g'],['环境条件 Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],'Location','SouthWest');
            %                     %                 legend(['试验 Grms=',num2str(obj.rms,'%7.3f') 'g'],['环境条件 Grms=' num2str(obj.tiaoJian_rms,'%7.2f') 'g'],['±3dB条件'],'Location','SouthWest'); %带±3dB条件
            %
            %
            %
            %                 end
            
            %             legend(strcat('试验 Grms=',num2str(rms,'%7.3f')),['振动条件 Grms=' num2str(tiaoJian_rms) 'g'],'Location','NorthWest');
            
            
        end
        
        % 从实域计算PSD
        function obj=calRmsFromFrequencyDomian(obj)
            %             obj.rms=calRMS_gongShi(obj.PSDResultOfFrequency,obj.PSDResultData);
            
            %                         obj.rms=calRMS_interp(obj.PSDResultOfFrequency,obj.PSDResultData);
            obj.rms=calRms_f(obj.PSDResultOfFrequency,obj.PSDResultData);
            
        end
        
        % 计算环境条件的rms
        function obj=calRmsForConditions(obj)
            %             obj.conditionsRms=calRMS_gongShi(obj.conditionsFre,obj.conditionsPSD);
            
            obj.conditionsRms=calRMS_interp(obj.conditionsFre,obj.conditionsPSD);
        end
        
        %绘环境条件
        function obj=plotCondition(obj,legendName,colorDefine)
            %             subplot(obj.hSubplot);
            %             subplot(2,1,2);
            %             obj.hPlot(end+1)=loglog(obj.conditionsFre,obj.conditionsPSD,'LineWidth',2,'color','red');
            
            
            %%ok
            %             obj.hPlot(end+1)=loglog(obj.conditionsFre,obj.conditionsPSD,'LineWidth',2);
            %             obj.legends{end+1}=['振动条件 Grms=' num2str(obj.conditionsRms) 'g'];
            
            %%
            
            
            switch nargin
                case 1
                    obj.hPlot(end+1)=loglog(obj.conditionsFre,obj.conditionsPSD,'LineWidth',2);
                    obj.legends{end+1}=['振动条件 Grms=' num2str(obj.conditionsRms,'%-7.3f') 'g'];
                case 2
                    obj.hPlot(end+1)=loglog(obj.conditionsFre,obj.conditionsPSD,'LineWidth',2,'color','red');
                    obj.legends{end+1}=legendName;
                case 3
                    obj.hPlot(end+1)=loglog(obj.conditionsFre,obj.conditionsPSD,'LineWidth',2,'color',colorDefine);
                    obj.legends{end+1}=legendName;
                otherwise
                    disp('plotCondition 参数个数错误！')
            end
            
            
            
            
            %             loglog(obj.conditionsFre,obj.conditionsPSD*10^(-3/10),'LineWidth',1.3,'color','green');%带±3dB条件
            %             loglog(obj.conditionsFre,obj.conditionsPSD*10^(3/10),'LineWidth',1.3,'color','green');
            
            %             legend(['试验 Grms=',num2str(obj.rms,'%7.3f') 'g'],['振动环境条件 Grms=' num2str(obj.conditionsRms) 'g'],'Location','NorthWest');
            %             legend(['试验 Grms=',num2str(obj.rms,'%7.3f') 'g'],['环境条件 Grms=' num2str(obj.conditionsRms,'%7.2f') 'g'],'Location','SouthWest');
            %             legend(['试验 Grms=',num2str(obj.rms,'%7.3f') 'g'],['环境条件 Grms=' num2str(obj.conditionsRms,'%7.2f') 'g'],['±3dB条件'],'Location','SouthWest'); %带±3dB条件           %
            %
            %
            %             legend(strcat('试验 Grms=',num2str(rms,'%7.3f')),['振动条件 Grms=' num2str(tiaoJian_rms) 'g'],'Location','NorthWest');
            
            
        end
        
        %所有图标出 lengend
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
        
        %绘制时域曲线
        function obj=plotTimeHistory(obj)
            drawVibrationTimeHis(obj.timeForCalculate,obj.dataForCalculate,obj.channelName);
        end
    end
    
end
