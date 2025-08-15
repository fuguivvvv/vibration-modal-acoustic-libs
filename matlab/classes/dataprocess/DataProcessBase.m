classdef DataProcessBase<handle
    %untitled2 summary of this class goes here
    %   detailed explanation goes here
    
    properties
        %fs
        fs=0;
        
        %ʱ��ʱ��������
        originalTime=0;
        
        %ʱ��ԭʼ����
        originalData=0;
        
        %����ν�ȡ��ʱ���Ὺʼʱ��
        startTimeforCalculate=0;
        
        %����ν�ȡ��ʱ�������ʱ��
        endTimeforCalculate=0;
        
        
        
        %���㷶Χ�ڵ�index
        index=0;
        %Ҫ�����ʱ���
        timeForCalculate=0;
        
        %����ν�ȡ������
        dataForCalculate=0;
        
        %ͨ������
        channelName='xxxͨ������';
        
        %%%��ͼ�ľ��
        hPlot=[];
        legends={};
        
        
        colors=[
            1 0.5 0;
            0 1 0;
            0.2 0 1;
            0.5 0.8 1;
            0 0.5 1;
            0.6 0.2 1;
            0.1 0.5 0.2;
            0.5 0.5 0.5;
            0.3 0.6 0.1;
            0 0.5 0.8;
            0.5 0.9 1;
            1 0.3 0.8;
            0.2 0.6 0.4;
            0.2 0.6 1;
            0.6 0.2 0.4];
        
    end
    
    methods
        %%���캯��
        function obj=DataProcessBase(fs,originalTime,originalData,channelName)
            
            switch nargin
                case 4                    
                    if(length(originalData)>=100)                        
                        obj.originalTime=originalTime;
                        obj.originalData=originalData;
                        obj.fs=fs;
                        obj.channelName=channelName;                        
                    end
                case 2
                    
            end
            
            
            
            %             obj.plottimehistory();
            
            %             if(nargin ~= 4)
            %                 sprintf('error:%s','��������������������������4,fs,originalTime,originalData,channelName');
            %                 return;
            %             end
        end
        
        
        
        function setDataForCalculate(obj,startTimeforCalculate,endTimeforCalculate)
%             a='obj.index'
%             obj.index
% %             obj.originalTime
%             startTimeforCalculate
%             endTimeforCalculate
            
            obj.index=find(obj.originalTime>=startTimeforCalculate & obj.originalTime<=endTimeforCalculate);

            if length(obj.index)<=0
                fprintf('error:%s\n','index����<=0, setDataForCalculate��ʼ������');
                return;
            end
            
            obj.startTimeforCalculate=startTimeforCalculate;
            obj.endTimeforCalculate=endTimeforCalculate;
            
            obj.timeForCalculate=obj.originalTime(obj.index);
            obj.dataForCalculate=obj.originalData(obj.index);
        end
        
        %��ʱ������
        function obj=plotTimeHistory(obj,xNLimits)
            if length(obj.timeForCalculate)==1 && obj.timeForCalculate==0
                fprintf('error:%s\n','plotTimeHistory��û�г�ʼ�� index');
                return;
            end
            nargin
            switch nargin
                case 2                    
                    drawShockTimeHis(obj.timeForCalculate,obj.dataForCalculate,obj.channelName,xNLimits);                    
                case 1
                    drawShockTimeHis(obj.timeForCalculate,obj.dataForCalculate,obj.channelName);                    
            end
            
            
            %             plot(obj.timeForCalculate,obj.dataForCalculate);
        end
        
        %����figure ��emf�ļ�
        function obj=saveFigAndEmf(obj)
            declareGlobalVars;
            saveas(gcf,[globalResultsPath '\' obj.channelName],'fig');
            saveas(gcf,[globalResultsPath '\' obj.channelName],'emf');
        end
        
        function obj=save(obj)
            declareGlobalVars;
            if nargin==2
                saveas(gcf,[globalResultsPath '\' NamePre '-' obj.channelName],'fig');
                saveas(gcf,[globalResultsPath '\' NamePre '-' obj.channelName],'emf');
            else
                saveas(gcf,[globalResultsPath '\' obj.channelName],'fig');
                saveas(gcf,[globalResultsPath '\' obj.channelName],'emf');
            end
        end
        function obj=saveFig(obj,NamePre)
            declareGlobalVars;
            if nargin==2
                saveas(gcf,[globalResultsPath '\' NamePre '-' obj.channelName],'fig');
            else
                saveas(gcf,[globalResultsPath '\' obj.channelName],'fig');
            end
        end
        function obj=saveEmf(obj)
            declareGlobalVars;
            
            if nargin==2
                saveas(gcf,[globalResultsPath '\'  NamePre '-' obj.channelName],'emf');
                
            else
                saveas(gcf,[globalResultsPath '\' obj.channelName],'emf');
            end
            
        end
        
    end
    
end
