classdef calssMyLog
    %MYLOG 此处显示有关此类的摘要
    %   此处显示详细说明
    properties
        logFilename=[];
        logPath='.\log\';
        fid=0;
    end
    
    methods
        
        function obj = calssMyLog(logFilename)
            obj.logFilename=logFilename;
        end
        
        function [] = writeLog(obj,varargin)
            
            obj.fid = fopen([obj.logPath obj.logFilename],'at');
            fidLoacl=obj.fid;
            %打开文件，‘at’表示以添加在原有内容末尾的方式写入
            fprintf(fidLoacl,'%s','[');
            fprintf(fidLoacl,'%s',datestr(now,0));
            %用fprintf函数来写入数据，datestr函数用来格式化时间 0表示时间格式为：dd-mmm-yyyy HH:MM:SS
            fprintf(fidLoacl,'%s','] ');
            %  %s指的是以字符串的形式输出，\n表示输出完毕后回车
            vararginStr{numel(varargin)}=0;
            for i = 1:length(varargin)
                
                switch class(varargin{i})                    
                    case 'char'
                        vararginStr{i}=varargin{i};                        
                    case 'double'
                        vararginStr{i}=num2str(varargin{i});
                    case 'float'
                        vararginStr{i}=num2str(varargin{i});                        
                    case 'int'
                        vararginStr{i}=num2str(varargin{i});                        
                    case 'cell'                                              
                        
                end
                
                fprintf(fidLoacl,'%s',vararginStr{i});
                
%                 if(mod(i,2) == 1)
%                     fprintf(fid,'%s',':');
%                 end
                
%                 if(mod(i,2) == 0)
%                     fprintf(fid,'%s\n',' ');
%                 end
                
            end
            
            fprintf(fidLoacl,'%s\n',';');
            
            fclose(fidLoacl);%不要忘了关闭文件
        end
        
        function []=closeLogFile(obj)
            fclose(obj.fid);%不要忘了关闭文件            
        end
    end
end
