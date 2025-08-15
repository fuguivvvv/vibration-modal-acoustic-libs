classdef DataProcessSRS<DataProcessBase
    %untitled2 summary of this class goes here
    %   detailed explanation goes here
    
    properties
        
        %频率开始
        startFrequencyForSRSCalculate=10;
        
        %频率结束
        endFrequencyforSRSCalculate=10000;
        
        
        %环境条件，频率
        conditionsFre=0;
        %环境条件 ，PSD
        conditionsSRS=0;
        
        %srs计算结果，频率
        SRSResultFrequency=0;
        
        %srs计算结果，频率数据
        SRSResultData=0;
        
        %有效持续时间
        TE=0;
        
        %时域峰值
        maxX=0;
        %时域峰值的index
        indexMaxX=0;
        
        hFigure=0;
        
        hAxisSRS=0;
        hTimeHis=0;
        
    end
    
    methods
        %%构造函数
        function obj=DataProcessSRS(fs,originalTime,originalData,channelName)
            
            obj=obj@DataProcessBase(fs,originalTime,originalData,channelName);
        end
        %计算srs
        function obj=calSRS(obj)
            
            x=obj.dataForCalculate;
            fmin=obj.startFrequencyForSRSCalculate;
            fmax=obj.endFrequencyforSRSCalculate;
            [s,f]=srsa(x,obj.fs,fmin,fmax,12,1);
            obj.SRSResultFrequency=f;
            obj.SRSResultData=s;
        end
        
        %绘SRS
        function obj=plotSRS(obj)
            
            if length(obj.timeForCalculate)==1 && obj.timeForCalculate==0
                fprintf('error:%s\n','plotSRS:还没有初始化 index');
                return;
            end
            
            obj.calSRS();
            obj.hFigure=figure;
            obj.hAxisSRS=gca;
            obj.hPlot(end+1)=loglog(obj.SRSResultFrequency,obj.SRSResultData);
            obj.legends{end+1}=['实测：' obj.channelName];
            hold on;
            grid on;
            set(gca,'XLim',[obj.startFrequencyForSRSCalculate obj.endFrequencyforSRSCalculate]);
            s_Y_lim=[min(obj.SRSResultData)/100 max(obj.SRSResultData)*20];
            
            set(gca,'YLim',s_Y_lim);
            
            [Pk_Minus,Pk_Plus,Pk_N_minus,Pk_N_Plus]=MyFindPeak(obj.SRSResultData);
            
            
            f=obj.SRSResultFrequency;
            
            %
            %             text(f(Pk_N_Plus),Pk_Plus,strcat('\leftarrow ',sprintf('%5.2f',Pk_Plus),'g,',sprintf('%5.2f',f(Pk_N_Plus)),...
            %                 'Hz'),'BackgroundColor',[.7 .9 .7],'FontSize',9);
            
            loglog(f(Pk_N_Plus),Pk_Plus,'Marker','*','Color','red');
            
            if f(Pk_N_Plus)<40
                text(40,Pk_Plus*1.5,strcat(sprintf('%5.2f',Pk_Plus),'g,',sprintf('%8.2f',f(Pk_N_Plus)),...
                    'Hz' ),'BackgroundColor',[.7 .9 .7],'FontSize',9);
                
                %         text(40,Pk_Plus*1.5,strcat('\leftarrow ',sprintf('%5.2f',Pk_Plus),'g,',sprintf('%8.2f',f(Pk_N_Plus)),...
                %         'Hz' ),'BackgroundColor',[.7 .9 .7],'FontSize',9);
            elseif f(Pk_N_Plus)>=40 &&  f(Pk_N_Plus)<1000
                text(f(Pk_N_Plus),Pk_Plus*1.5,strcat(sprintf('%5.2f',Pk_Plus),'g,',sprintf('%5.2f',f(Pk_N_Plus)),...
                    'Hz' ),'BackgroundColor',[.7 .9 .7],'FontSize',9);
                
                
                %         text(f(Pk_N_Plus),Pk_Plus*1.5,strcat(sprintf('%5.2f',Pk_Plus),'g,',sprintf('%5.2f',f(Pk_N_Plus)),...
                %         'Hz' ,'\rightarrow '),'BackgroundColor',[.7 .9 .7],'FontSize',9);
            else
                %         text(1000,Pk_Plus*1.5,strcat(sprintf('%5.2f',Pk_Plus),'g,',sprintf('%5.2f',f(Pk_N_Plus)),...
                %         'Hz' ,'\rightarrow '),'BackgroundColor',[.7 .9 .7],'FontSize',9);
                
                text(1000,Pk_Plus*1.5,strcat(sprintf('%5.2f',Pk_Plus),'g,',sprintf('%5.2f',f(Pk_N_Plus)),...
                    'Hz' ),'BackgroundColor',[.7 .9 .7],'FontSize',9);
            end
            
            
            xlabel('频率(Hz)');
            ylabel({'峰' '值' '(g)'},'Rotation',0,'VerticalAlignment','middle');
            %             legend(obj.channelName,2);
            title( ['冲击响应谱--' obj.channelName],'FontSize',15);
            
            obj.hTimeHis=axes('position',[0.59 0.18 0.3 0.3]);
            %     t=0:1/fs:(length(x)-1)/fs;
            %     plot(1000*t,x);
            plot(obj.timeForCalculate,obj.dataForCalculate);
            %             obj.hPlot(end+1)=plot(obj.timeForCalculate,obj.dataForCalculate);
            hold on;
            grid on;
            % xlabel('时间(ms)','fontsize',7);
            xlabel('时间(s)','fontsize',7);
            ylabel({'加' '速' '度' '(g)'},'fontsize',7,'Rotation',0,'VerticalAlignment','middle');
            set(gcf,'Position',[ 0 0 700 500]);
            set(gca,'YLim',[min(obj.dataForCalculate)*1.2 max(obj.dataForCalculate)*1.5]);
            set(gca,'XLim',[min(obj.timeForCalculate) max(obj.timeForCalculate)]);
            
            [TE,Te]=calTE(obj.dataForCalculate,obj.fs);
            % legend(['TE=' sprintf('%5.2f',TE*1000)  's']);
            %             legend(['TE=' sprintf('%6.2f',TE*1000)  'ms']);
            obj.calTEAndMax;
            legend(['最大峰值：' sprintf('%6.2f',obj.maxX)  'g']);
            %             obj.legends{end+1}=['TE=' sprintf('%6.2f',TE*1000)  'ms'];
            obj.calTEAndMax();
            
            %             loglog(obj.SRSResultFrequency,obj.SRSResultData);
        end
        
        function obj=calTEAndMax(obj)
            [TE,Te]=calTE(obj.dataForCalculate,obj.fs);
            obj.TE=TE*1000;
            [maxX,indexMaxX]=max(abs(obj.dataForCalculate));
            obj.maxX=maxX;
            obj.indexMaxX=indexMaxX;
        end
        
        function obj=plotCondition(obj,legendName,colorDefine)
            axes(obj.hAxisSRS);
            switch nargin
                case 2
                    obj.hPlot(end+1)=loglog(obj.hAxisSRS,obj.conditionsFre,obj.conditionsSRS,'LineWidth',2,'color','red');
                case 3
                    obj.hPlot(end+1)=loglog(obj.hAxisSRS,obj.conditionsFre,obj.conditionsSRS,'LineWidth',2,'color',colorDefine);
                otherwise
                    disp('plotCondition 参数个数错误！')
            end
            
            obj.legends{end+1}=legendName;
            %             legend({'飞行试验','冲击环境条件'},'Location','NorthWest');
            axes(obj.hTimeHis);
            
            
        end
        
        function obj=lengendAll(obj,location)
            hL=legend(obj.hPlot(:),obj.legends{:},'Location',location);
            %             set(hL,'FontSize',0.01);
            %                         legend(obj.legends{:},'Location','NorthWest','FontSize','1');
            
        end
        
        
    end
    
end
