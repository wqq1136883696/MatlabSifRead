function newList = DeleteOneFileFromList(list,number)
            %
            % DeleteOneFileFromList(list,number)    ɾ��һ��ֵ���б���
            %
%           ��������� list һ���б�
%                      number Ҫɾ����ֵ��λ��
%
%           ��������� �µ��б�
% 
            sizeList = length(list);
            
            if number < 1
                number = 1;
            elseif number > sizeList
                number = sizeList;
            end  
            
            newList = list(1:number-1);
            newList(number:sizeList-1) = list(number+1:sizeList); 
        end