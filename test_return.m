function a = test_return(num)
    if num == 1
        disp("hello");
    elseif num == 0
        return
    end
    
    disp("end");

end
