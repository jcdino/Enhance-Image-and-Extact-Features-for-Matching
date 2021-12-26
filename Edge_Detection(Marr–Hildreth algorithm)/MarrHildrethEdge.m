function result = MarrHildrethEdge(im, sigma, threshold)

% Laplacian of Gaussian filter�� weight�� ����
filterSize = 2*ceil(3*sigma);
%sigma�� �̿��ؼ� Laplacian of Gaussian filter�� size�� ����
halfFs = floor(filterSize/2);
% Laplacian of Gaussian filter�� size�� �� ũ�⸦ ����

weight = zeros(filterSize,filterSize);
% Laplacian of Gaussian filter�� ����ķ� ����
for y = -halfFs:-halfFs+filterSize-1
    for x = -halfFs:-halfFs+filterSize-1
        weight(y+halfFs+1,x+halfFs+1) = ((y^2+x^2-2*sigma^2) / (sigma^4)) * (1/(2*pi*sigma^2) * exp(-(y^2+x^2) / (2*sigma^2)));
        % x�� y�� ���ؼ� 2�� ��̺��� ���� ��Ÿ���� ���� gaussian funciton��
        % (y^2+x^2-2*sigma^2) / (sigma^4)�� ���� ������ �� ��ǥ�� ���� �����Ѵ�.
    end
end

weight_avg = mean(weight, 'all');
% filter�� weight������ ����� ����

for y = 1:size(weight,1)
    for x = 1:size(weight,2)
        weight(y,x) = weight(y,x) - weight_avg;
        % weight�� ��� ������ ���� 0�� �Ǳ� ���ؼ�, ��� ���� ��ո�ŭ ����
    end
end



conv_result = zeros(size(im));
% Laplacian of Gaussian filter�� �Է¿����� convolution�� ���� 
% ������ ���� conv_result�� ����ķ� ����
for ch = 1:size(im,3) 
    for y = 1:size(im,1) 
        for x = 1:size(im,2)
            for s = -halfFs:-halfFs+filterSize-1 
                for t = -halfFs:-halfFs+filterSize-1 
                    ys = y-s;
                    xt = x-t;
                    % ������ ��� ���� �������� ������ �� ��ǥ�� �����Ǵ� im������ ��ǥ�� ys, xt�� ��Ÿ��
                    if ys <1; ys = 1; end
                    if xt <1; xt = 1; end
                    if ys > size(im,1); ys = size(im,1); end
                    if xt > size(im,2); xt = size(im,2); end
                    % replicate padding ����� ������ �ڵ�
                    % ���Ͱ� y �� 0���� �۰ų� size(im,1)���� ū ��ǥ�� ���̳�
                    % x�� 0���� �۰ų� size(im,2)���� ū ��ǥ�� ���� ����ؼ� ����Ϸ��� �Ҷ�
                    % replicate padding�� ���ؼ� ���� ����� pixel�� ���� ����ϵ��� �ڵ��Ͽ���
                    
                    conv_result(y,x,ch) = conv_result(y,x,ch)+weight(s+halfFs+1,t+halfFs+1)*im(ys,xt,ch);
                    % Laplacian of Gaussian filter�� �Է¿����� convolution�� ����
                    % conv_result�� �ش� ��ǥ�� ����
                end
            end
        end
    end
end


% threshold ���ϱ�
max = 0;
% conv_result�� �� �� ���� ū ���� ������ ���� max�� 0���� ����
for ch = 1:size(conv_result,3) 
    for y = 1:size(conv_result,1) 
        for x = 1:size(conv_result,2)
            if conv_result(y,x,ch) > max; max=conv_result(y,x,ch);end
            % conv_result�� ��� ���� �ϳ��� Ȯ���ؼ� ���� max���� ũ�� ���� max�� ���� �ش� ������ �ٲ��־�
            % ���� max�� ���� ū ���� ������ ���ش�.
        end
    end
end
new_threshold = threshold * max;
% threshold���� �ս� ���� conv_result�� �� �� ���� ū ���� ������ ���� threshold�� ���� ���ؼ� ���Ѵ�.



result = zeros(size(im));
% ��� ���� result�� ����ķ� ����
bounded = zeros(3,3,size(im,3));
% zero-crossing�� �Ǵ��ϴµ� �ʿ��� ��ǥ���� ������ ���� ũ�⸦ ����

for ch = 1:size(conv_result,3) 
    for y = 1:size(conv_result,1) 
        for x = 1:size(conv_result,2)
            for s = -1:1
                for t = -1:1
                    ys = y+s;
                    xt = x+t;
                    % ������ ��� ���� �������� ������ �� ��ǥ�� �����Ǵ� conv_result������ ��ǥ�� 
                    %ys, xt�� ��Ÿ��
                    if ys <1; ys = 1; end
                    if xt <1; xt = 1; end
                    if ys > size(conv_result,1); ys = size(conv_result,1); end
                    if xt > size(conv_result,2); xt = size(conv_result,2); end
                    % replicate padding ����� ������ �ڵ�
                    % ���Ͱ� y �� 0���� �۰ų� size(conv_result,1)���� ū ��ǥ�� ���̳�
                    % x�� 0���� �۰ų� size(conv_result,2)���� ū ��ǥ�� ���� ����ؼ� ����Ϸ��� �Ҷ�
                    % replicate padding�� ���ؼ� ���� ����� pixel�� ���� ����ϵ��� �ڵ��Ͽ���
                    
                    bounded(s+1+1,t+1+1,ch) = conv_result(ys,xt,ch);
                    % �ش� pixel�� ���� �����Կ� �־� zero-crossing�� �Ǵ��ϱ� ���� �ʿ��� �������
                    % ��� bounded�� ����
                end
            end
            count = 0;
            % �ش� pixel���� zero-crossing�� �̷���� ������ counting�ϱ� ���� ���� ����
            if (median([bounded(2,1,ch),0,bounded(2,3,ch)]) == 0) && ...
                    (abs(bounded(2,1,ch)-bounded(2,3,ch))>new_threshold); count=count+1;end
            % �ش� pixel �������� ��, �Ʒ� pixel ���� ��ȣ�� �ݴ��̰� �� ���� �A ���� ���밪�� 
            % threshold���� ũ�� zero-crossing�̶�� �Ǵ��Ͽ� count�� 1��ŭ �ø���.
            if (median([bounded(1,2,ch),0,bounded(3,2,ch)]) == 0) && ...
                    (abs(bounded(1,2,ch)-conv_result(3,2,ch))>new_threshold);count=count+1;end
            % �ش� pixel �������� �¿� pixel ���� ��ȣ�� �ݴ��̰� �� ���� �A ���� ���밪�� 
            % threshold���� ũ�� zero-crossing�̶�� �Ǵ��Ͽ� count�� 1��ŭ �ø���.
            if (median([bounded(1,1,ch),0,bounded(3,3,ch)]) == 0) && ...
                    (abs(bounded(1,1,ch)-bounded(3,3,ch))>new_threshold);count=count+1;end
            % �ش� pixel �������� ���� ��, ������ �Ʒ� pixel ���� ��ȣ�� �ݴ��̰� �� ���� �A ���� ���밪�� 
            % threshold���� ũ�� zero-crossing�̶�� �Ǵ��Ͽ� count�� 1��ŭ �ø���.
            if (median([bounded(1,3,ch),0,bounded(3,1,ch)]) == 0) && ...
                    (abs(bounded(1,3,ch)-bounded(3,1,ch))>new_threshold);count=count+1;end
            % �ش� pixel �������� ������ ��, ���� �Ʒ� pixel ���� ��ȣ�� �ݴ��̰� �� ���� �A ���� ���밪�� 
            % threshold���� ũ�� zero-crossing�̶�� �Ǵ��Ͽ� count�� 1��ŭ �ø���.
            if count >=2; result(y,x,ch) =1;end
            % count�� 2���� ũ�� 2�� �̻� �� ��, zero-crossing�� 2�� �̻��̹Ƿ� edge��� �Ǵ��Ͽ�
            % ��¿����� �ش� ��ǥ���� 1�� �������ش�.
        end
    end
end





