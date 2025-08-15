classdef MyPSD
    %UNTITLED 此处显示有关此类的摘要
    %   此处显示详细说明
    
    properties
        frequency=[];
        psdData=[];
        
        time=[];
        timeData=[];
        fs=[];
        
        rms=0;
        fre_start=10;
        fre_end=2000;
        channelName='';
        
        condition1_fre=[];
        condition1_psd=[];
        
        condition2_fre=[];
        condition2_psd=[];
        
        condition3_fre=[];
        condition3_psd=[];
        
        condition4_fre=[];
        condition4_psd=[];
        
    end
    
    properties (Hidden)
        index=[];
        hPlot=[];
        legendStr={};
    end
    
    methods
        function obj=MyPSD(frequency,psdData,fre_start,fre_end,channelName,rms)
            switch nargin
                case 0
                    
                case 1
                    
                case 2
                    
                case 3
                    
                case 4
                    
                case 5
                    
                case 6
                    
            end
            
            
            
            
        end
        
        function obj = calRms(obj)
            if isempty(obj.index)
                calIndex;
            end
            obj.rms=sqrt(trapz(obj.frequency(obj.index),obj.psdData(obj.index)));
        end
        function obj= plotPsd(obj,axIn,legendStr)
            
            if isempty(obj.index)
                calIndex;
            end
            switch nargin
                case 1
                    ax=gca;
                case 2
                    ax= axIn;
                case 3
                    ax= axIn;
            end
            
            
            obj.hPlot(end+1)=loglog(ax,obj.frequency(obj.index),obj.psdData(obj.index));
            
        end
        
    end
    
    methods (Hidden)
        
        function obj = calIndex(obj)
            obj.index=find(obj.frequency>=obj.fre_start && obj.frequency<=obj.fre_end);
        end
        
    end
end

