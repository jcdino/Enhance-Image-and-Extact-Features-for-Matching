
function result = SobelEdge(im)

im_double = im2double(im);
% �Է� ������ pixel������ uint8������ double������ �ٲ��ش�.
h = size(im_double,1);
% �Է� ������ ���̸� h ������ ����
w = size(im_double,2);
% �Է� ������ �ʺ� w ������ ����
gy = zeros(size(im_double,1),size(im_double,2));
% y������ gradient�� ���� ����� ������ ���� gy�� ��� 0�� �ǵ��� ����
gx = zeros(size(im_double,1),size(im_double,2));
% x������ gradient�� ���� ����� ������ ���� gx�� ��� 0�� �ǵ��� ����
result = zeros(size(im_double,1),size(im_double,2));
% ���� ������� ������ ���� result�� ���� ��� 0�� �ǵ��� ����

% filter�� ���� �� ����
gy_filter = [1,2,1;0,0,0;-1,-2,-1];
% gy�� �����Կ� �־� ���Ǵ� ������ ������ �������ش�.
gx_filter = [1,0,-1;2,0,-2;1,0,-1];
% gx�� �����Կ� �־� ���Ǵ� ������ ������ �������ش�.
halfFs = 1;
% gx_filter�� gy_filter�� ũ���� �ݰ��� �������ش�.

% y�࿡ ���� gradient�� ������ gy, x�࿡ ���� gradient�� ������ gx�� �� ����
for ch = 1:size(im,3) % im_double, gx, gy�� channel�� ���� ����
    for y = 1:h % im_double, gx, gy�� ���� ���� ����
        for x = 1:w % im_double, gx, gy�� �ʺ� ���� ����
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
                    gy(y,x,ch) = gy(y,x,ch)+gy_filter(s+halfFs+1,t+halfFs+1)*im_double(ys,xt,ch);
                    gx(y,x,ch) = gx(y,x,ch)+gx_filter(s+halfFs+1,t+halfFs+1)*im_double(ys,xt,ch);
                    % filter�� ���� filter�� ��ġ�� �����ϴ� �Է� ������ pixel������ �������� ���ְ� ��
                    % ������ ���� ���� filter�� (1,1) ��ġ�� �����ϴ� gy�� gx�� pixel ������ �������ش�. 
                end
            end
        end
    end
end

% ���� ��� ������ �����ϴ� ���� 
for ch = 1:size(im,3) % result, gx, gy�� channel�� ���� ����
    for y = 1:h % result, gx, gy�� ���� ���� ����
        for x = 1:w % result, gx, gy�� �ʺ� ���� ����
            result(y,x,ch) = sqrt(gy(y,x,ch)^2+gx(y,x,ch)^2);
            % edge magnitude�� ���ϴ� ������ ����ؼ� gy�� gx�� ������ ��ġ�� pixel�� �ش��ϴ�
            % ���� ��� ���� result�� �� pixel���� ���� �����Ѵ�.
        end
    end
end
