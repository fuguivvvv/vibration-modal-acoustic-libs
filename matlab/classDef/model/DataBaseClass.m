classdef DataBaseClass
    %DATABASECLASS �˴���ʾ�йش����ժҪ
    %   �˴���ʾ��ϸ˵��
    
    properties
        time=[];
        frequency=[];
        data=[];
        rms=[];
        fs=[];
        chanelName='';
    end
    methods
        function obj = DataBaseClass()
        end
        
        function obj = plot(obj)
        end
        
        function obj = saveFig(obj)
        end
    end
end

