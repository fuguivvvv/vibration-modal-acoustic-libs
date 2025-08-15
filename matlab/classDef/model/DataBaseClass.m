classdef DataBaseClass
    %DATABASECLASS 此处显示有关此类的摘要
    %   此处显示详细说明
    
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

