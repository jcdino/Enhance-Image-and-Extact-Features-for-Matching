
function result = bilinearInterpolation(im, scale)
% �ʱ� �������� ���� �����ִ� ����
h = size(im,1);
% �̹����� ���̸� ���� h�� ����
w = size(im,2);
% �̹����� �ʺ� ���� w�� ����
result = zeros(h*scale,w*scale,'uint8');
% scale��ŭ ������ ��� ������ ��� 0���� �ʱ�ȭ�� uint8������ ����� ���� result�� ����

% ���� im�� pixel������ ��� ���� ��Ŀ� �Է��ϴ� ����
for ch=1:size(im,3)
    for y = 1:h
        for x = 1:w
            result(scale*(y-1)+1,scale*(x-1)+1,ch) = im(y,x,ch);
            % im�� �ִ� �ȼ������� result�� (scale-1)���� pixel ������ �ΰ� ��ġ�Ѵ�.
        end
    end
end

%%

% result���� im�� pixel������ �� ��� �� ��, ���� 0�� pixel�� ������ ä��� ����
for ch=1:size(result,3)
    for y = 1:h
        for x = 1:(w-1)
            for j = 1:(scale-1)
                result(scale*(y-1)+1,scale*(x-1)+1+j,ch) = im(y,x,ch)/(scale)*(scale-j) + im(y,x+1,ch)/(scale)*j;
                % im�� pixel������ �� �࿡ ���ؼ� �� ���� �� pixel�� ä���ִ� ����
                % ��� �ִ� pixel�� ��������, ���� �࿡�� �� �� ���� �����ϴ� pixel�� ���� �Ÿ��� ����ؼ� ������
                % �� ���� ����ġ�� �����༭ ���� ���� ���� ����ִ� pixel�� ���� �����ش�.
            end
        end
    end
end

for ch=1:size(result,3)
    for x = 1:w
        for y = 1:(h-1)
            for i = 1:(scale-1)
                result(scale*(y-1)+1+i,scale*(x-1)+1,ch) = im(y,x,ch)/(scale)*(scale-i) + im(y+1,x,ch)/(scale)*i;
                % im�� pixel������ �� �࿡ ���ؼ� �� ���� �� pixel�� ä���ִ� ����
                % ��� �ִ� pixel�� ��������, ���� �࿡�� �� �� ���� �����ϴ� pixel�� ���� �Ÿ��� ����ؼ� ������
                % �� ���� ����ġ�� �����༭ ���� ���� ���� ����ִ� pixel�� ���� �����ش�.
            end
        end
    end
end

%%
% �� ���� ���Ŀ� ���� �ִ� �� pixel�� ���� ä��� ���� 
for ch=1:size(im,3)
    for y = 1:h-1
        for x = 1:w-1
            for m = 1:(scale-1)
                for k = 1:(scale-1)
                    result(scale*(y-1)+1+m,scale*(x-1)+1+k,ch) = result(scale*(y-1)+1+m,scale*(x-1)+1,ch)/scale*(scale-k) + result(scale*(y-1)+1+m,scale*(x-1)+1+scale,ch)/scale*k;
                    % ��� �ִ� pixel �� �ϳ��� ����, pixel �������� ���� ���� �ִ� ����� �� pixel�� ���� ã�´�.(vertical first)
                    % �� pixel�� �� �� pixel�� �Ÿ��� �������� ����ġ�� ũ�����Ͽ� ���� ���Ѱ��� �� pixel�� ���� �����Ѵ�.
                end
            end
        end
    end
end

% �� ���� ���Ŀ� ���� �ִ� �� pixel�� ���� ä��� ���� 
% for ch=1:size(im,3)
%     for y = 1:h-1
%         for x = 1:w-1
%             for m = 1:(scale-1)
%                 for k = 1:(scale-1)
%                     result(scale*(y-1)+1+m,scale*(x-1)+1+k,ch) = result(scale*(y-1)+1,scale*(x-1)+1+k,ch)/scale*(scale-m) + result(scale*(y-1)+1+scale,scale*(x-1)+1+k,ch)/scale*m;
%                     % ��� �ִ� pixel �� �ϳ��� ����, pixel �������� ���� ���� �ִ� ����� �� pixel�� ���� ã�´�.(Horizontal first)
%                     % �� pixel�� �� �� pixel�� �Ÿ��� �������� ����ġ�� ũ�����Ͽ� ���� ���Ѱ��� �� pixel�� ���� �����Ѵ�.
%                 end
%             end
%         end
%     end
% end

%%
% result�� �����ʰ� �Ʒ����� pixel �� ���� ���� pixel���� ���� �������ִ� ���� 
for ch = 1:size(result,3)
    for y = 1:size(result,1)
        for x = 1:size(result,2)
            if x > scale*(w-1)+1
                result(y,x,ch) = result(y,scale*(w-1)+1,ch);
                % im�� ���� �����ʿ� �ִ� ���� �� pixel�麸�� ū x�鿡 ���ؼ� 
                % ���� ���� im�� ���� �����ʿ� �ִ� ���� ������ �Ѵ�.
            end
            if y > scale*(h-1)+1
                result(y,x,ch) = result(scale*(h-1)+1,x,ch);
                % im�� ���� �Ʒ��� �ִ� ���� �� pixel�麸�� ū y�鿡 ���ؼ� 
                % ���� ���� im�� ���� �Ʒ��� �ִ� ���� ������ �Ѵ�.
            end
        end
    end
end


