function newList = DeleteOneFileFromList(list,number)
            %
            % DeleteOneFileFromList(list,number)    删除一个值从列表中
            %
%           输入参数： list 一个列表
%                      number 要删除的值的位置
%
%           输出参数： 新的列表
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