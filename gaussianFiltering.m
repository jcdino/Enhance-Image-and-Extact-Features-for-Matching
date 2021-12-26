
function result = gaussianFiltering(im, sigma)
%%
%Gaussian Filter ����
filterSize = 2*round(sigma*2)+1; 
% Ȧ���� filterSize ����
halfFs = (filterSize-1)/2;
% ������ ���ϴ�, ������ ��ǥ���� ���ؼ� ������ ũ�⸦ ���Ѵ�.

weight = zeros(filterSize, filterSize);
% 0���� ������ gaussian filter�� weight��� ��ķ� ����

for y = -halfFs : halfFs %-2 ~ 2
    for x = -halfFs : halfFs %-2 ~ 2
        weight(y+halfFs+1,x+halfFs+1) = 1/(2*pi*sigma^2) * exp(-(y^2+x^2) / (2*sigma^2));
        % ��� weight�� �� ��� ���� ���� �Է��������ν� weight���� �Էµ� gaussian filter ����
    end
end
weight = weight / sum(weight, 'all');
% gaussian filter�� ��ü weight���� ������ �����༭ ���� gaussian filter �ϼ�
%%

%Gaussian filtering ����
result = zeros(size(im));
% ��� result�� image�� ũ�Ⱑ ���� ����ķ� ������

for ch = 1:size(im,3) % im�� result�� channel�� ���� ����
    for y = 1:size(im,1) % im�� result�� ���� ���� ����
        for x = 1:size(im,2)
            % im�� result�� �ʺ� ���� ����
            for s = -halfFs:halfFs % ������ ���� ���� ����
                for t = -halfFs:halfFs % ������ �ʺ� ���� ����
                    ys = y-s;
                    xt = x-t;
                    % ������ ��� ���� �������� ������ �� ��ǥ�� �����Ǵ�
                    % im������ ��ǥ�� ys, xt�� ��Ÿ��
                    if ys <1; ys = 1; end
                    if xt <1; xt = 1; end
                    if ys > size(im,1); ys = size(im,1); end
                    if xt > size(im,2); xt = size(im,2); end
                    % replicate padding ����� ������ �ڵ�
                    % ���Ͱ� y �� 0���� �۰ų� size(im,1)���� ū ��ǥ�� ���̳�
                    % x�� 0���� �۰ų� size(im,2)���� ū ��ǥ�� ���� ����ؼ� ����Ϸ��� �Ҷ�
                    % replicate padding�� ���ؼ� ���� �Ʊ�� pixel�� ���� ����ϵ��� �ڵ��Ͽ���

                    result(y,x,ch) = result(y,x,ch) + weight(s+halfFs+1,t+halfFs+1)*im(ys,xt,ch);
                    % �� result�� ��ǥ�� weight�� ������ im�� ������ �����༭
                    % gaussian filtering�� ����� ���� ������ �ϼ��Ѵ�.
                end
            end
       end
    end
end
end

