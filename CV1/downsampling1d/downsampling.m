h  = 1/16 * [ 1 4 6 4 1 ];
pyramid_levels = 5;
downsampled = cell(1, pyramid_levels+1);
signal = rand(1,9000);

downsampled = downsampling1d(signal,pyramid_levels,h);
up = upsampling_signal(downsampled,pyramid_levels);

out = up - downsampled{1};
%plot(out);
function [downsampled] = downsampling1d(signal,levels,core)
    downsampled{1} = conv(signal,core);
    for level=2: levels
        downsampled{level} = conv(downsampled{level-1}(1:2:end), core);
    end
    for level=1:levels
        figure(level), plot(downsampled{level});
    end
end

function [upsampled] = upsampling_signal(A,pyramid_levels) 
    for level=pyramid_levels:-1:1
        upsampled = A{level(1:2^level:end)};
    end
end

function [padding] = zero_padding(A,B)
    [rowsA,colsA] = size(A);
    [rowsB,colsB] = size(B);
    padding = zeros(1, colsA-colsB);
end



