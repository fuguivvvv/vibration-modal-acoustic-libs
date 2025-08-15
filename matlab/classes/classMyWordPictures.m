classdef classMyWordPictures<handle
    % 当完成绘图后，抓图到word中，并在图形下方标准出通道（曲线）名称
    properties
        wordFileName='';
        channelName;
        hWord;
        hDoc;
    end
    methods
        function obj=classMyWordPictures(wordFileName)
            obj.wordFileName=wordFileName;
            obj.hWord=actxserver('Word.Application');
            obj.hWord.Visible=1;
            obj.hDoc=obj.hWord.Documents.Add;
            obj.hDoc.Content.Paragraphs.Alignment='wdAlignParagraphCenter';
        end
        function  addPic(obj,channelName)                                      
            obj.hWord.Selection.Start=obj.hDoc.Content.end;
            print(gcf,'-dmeta');   
            obj.hWord.Selection.Paste;
        
            obj.hWord.Selection.Start=obj.hDoc.Content.end;
            obj.hWord.Selection.TypeParagraph;
            
            obj.channelName=channelName;
            obj.hWord.Selection.Text=obj.channelName;
            %回车
            obj.hWord.Selection.Start=obj.hDoc.Content.end;
            obj.hWord.Selection.TypeParagraph;
        end
        function save(obj)
            invoke(obj.hDoc,'Saveas',obj.wordFileName);
            invoke(obj.hDoc,'close');
            invoke(obj.hWord,'Quit');
            delete(obj.hWord);
        end
    end
end

