classdef calssSingletonGlobaVars
    %CALSSSINGLETONGLOBAVARS 此处显示有关此类的摘要
    %   project
    %   的单例变量类，所有的系统级变量都放在这个类里面（全局变量），
    %  当每个函数/类调用全局变量时候，用getInstance得到实例
    
    properties
        globalResultsPath='';
        globalMatDataPath='';
        globalSourceDataPath='';
        globalMFilePath='';
        
        globalUserpath=userpath;
        
        globalColors=[];
        
        globalFs=[];
        globalXlim=[];
        globalYlim=[];
        
        hInstance=[];
        
    end
    
    methods
        function obj = calssSingletonGlobaVars(globalResultsPath,globalMatDataPath,globalSourceDataPath,...
                globalMFilePath)
            
            switch nargin
                case 1
                    obj.globalResultsPath=globalResultsPath;
                case 2
                    obj.globalResultsPath=globalResultsPath;
                    obj.globalMatDataPath=globalMatDataPath;
                case 3
                    obj.globalResultsPath=globalResultsPath;
                    obj.globalMatDataPath=globalMatDataPath;
                    obj.globalSourceDataPath=globalSourceDataPath;
                case 4
                    obj.globalResultsPath=globalResultsPath;
                    obj.globalMatDataPath=globalMatDataPath;
                    obj.globalSourceDataPath=globalSourceDataPath;
                    obj.globalMFilePath=globalMFilePath;
            end
            
            obj.setGlobalColoers;
        end
        
        
        function setGlobalColoers(obj)
            
            obj.globalColors=[
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
            
            ii=5;
            jj=5;
            kk=5;
            
            for i=0:1/ii:1
                for j=0:1/jj:1
                    for k=0:1/kk:1
                        obj.globalColors(end+1,:)=[i j k];
                    end
                end
            end
        end
        
        function obj = getInstance(obj)
            
        end
    end
end

