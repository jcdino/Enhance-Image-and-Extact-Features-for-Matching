
function result = medianFiltering(im, filterSize)

filterNums = zeros(filterSize(1)*filterSize(2),1,'uint8');
% zeros���� ������'uint8'�� ��� medianNums ����
% filter�� ũ�� �ȿ� �ִ� ���ڵ��� ��� ���� ���� ���
result = zeros(size(im),'uint8');
% �Է¿���� ũŰ�� ���� 'uint8'�� ��� result ����
halfH = round((filterSize(1)-1)/2);
% �߾Ӱ��� (0,0)�� �� �ٸ� �ȼ����� ��ǥ�� ���ϰ� ���ϱ� ���ؼ� 
% filter ������ �ݿ� ���� �ϴ� ���� halfH ����
halfW = round((filterSize(2)-1)/2);
% �߾Ӱ��� (0,0)�� �� �ٸ� �ȼ����� ��ǥ�� ���ϰ� ���ϱ� ���ؼ� 
% filter �ʺ��� �ݿ� ���� �ϴ� ���� halfW ����

for ch = 1: size(im,3)  % im�� result�� channel�� ���� ����
    for y = 1:size(im,1)  % im�� result�� ���� ���� ����
        for x = 1:size(im,2)  % im�� result�� �ʺ� ���� ����
            count = 1;  
            % filterNums�� y��ǥ������, ������ ���� ���� ������ ��� filterNums�� ����Ǹ� 
            % ���ο� ���� ������ �����ϱ� ���� ���� count�� ���� 1�� �ʱ�ȭ�Ͽ� �ٽ� �����ϱ� ����
            for s = -halfH : halfH  % ������ ���� ���� ����
                for t = -halfW : halfW  % ������ �ʺ� ���� ����
                    ys = y+s;  % ������ ��ġ�� �����ϴ� �Է� ���󿡼��� ���� ��ǥ��
                    xt = x+t;  % ������ ��ġ�� �����ϴ� �Է� ���󿡼��� �ʺ� ��ǥ��
                    if ys <1; ys = 1; end
                    if xt <1; xt = 1; end
                    if ys > size(im,1); ys = size(im,1); end
                    if xt > size(im,2); xt = size(im,2); end
                    % replicate padding ����� ������ �ڵ�
                    % ���Ͱ� y �� 0���� �۰ų� size(im,1)���� ū ��ǥ�� �� �Ǵ�
                    % x�� 0���� �۰ų� size(im,2)���� ū ��ǥ�� ���� ����ؼ� ����Ϸ��� �Ҷ�
                    % replicate padding�� ���ؼ� ���� �Ʊ�� pixel�� ���� ����ϵ��� �ڵ��Ͽ���
                    
                    filterNums(count,1,ch) = im(ys,xt,ch);
                    % filter ���� �ȿ� �ִ� �Է� ������ ������ ��� filterNums�� ��� �־��� 
                    count = count+1;
                    % filterNums�� filter�� ���� �ȿ� �ִ� ������ ��� �� �� �ֵ��� filterNums�� y��ǥ�� 1�� �÷��ش�.
                    medianNum = median(filterNums);
                    % filterNums�� �ִ� ���� �� ������� �������� �� �߰��� �ִ� ���� �����ؼ� ����
                    % medianNum�� ������ ����
                    result(y,x,ch) = medianNum;
                    % ���� medianNum�� ���� ��� result�� (y,x,ch)�� ����
                end
            end
        end
    end
end
end
