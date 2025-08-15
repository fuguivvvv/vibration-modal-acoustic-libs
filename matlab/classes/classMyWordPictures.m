classdef classMyWordPictures<handle
    % ����ɻ�ͼ��ץͼ��word�У�����ͼ���·���׼��ͨ�������ߣ�����
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
            %�س�
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

