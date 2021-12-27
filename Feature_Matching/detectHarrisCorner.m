function [corner, C]=detectHarrisCorner(im, fx_operator, fy_operator, Gaussian_sigma, alpha, C_thres, NMS_ws)
%%
im = double(rgb2gray(im)); %im�� rgb���� gray scale�� ��ȯ
fx = zeros(size(im)); %x�࿡ ���� gradient�� ��Ÿ���� �̹��� 
fy = zeros(size(im)); %x�࿡ ���� gradient�� ��Ÿ���� �̹��� 

for y=1:size(im,1)
    for x=1:size(im,2)
        a = x+1; %x�࿡ ���ؼ� ���������� ���� x��ǥ ��ġ
        b = y+1; %y�࿡ ���ؼ� �Ʒ������� ���� y��ǥ ��ġ
        if a>size(im,2); a=x;end %im�� ������ �Ѿ�� ��ó�� �ִ� pixel�� ������ padding
        if b>size(im,1); b=y;end %im�� ������ �Ѿ�� ��ó�� �ִ� pixel�� ������ padding
        fx(y,x) = im(y,x)*fx_operator(1,1)+im(y,a)*fx_operator(1,2);
        %x�� ����(������)���� derivatives�� ����Ͽ� ���� ���̸� �����Ѵ�.
        fy(y,x) = im(y,x)*fy_operator(1,1)+im(b,x)*fy_operator(2,1);
        %y�� ����(�Ʒ���)���� derivatives�� ����Ͽ� ���� ���̸� �����Ѵ�.
    end
end
fx2 = fx.*fx;
fy2 = fy.*fy;
fxfy = fx.*fy;
%fx�� ����, fy�� ����, fx�� fy�� ���� ���� ���� ���� ������ش�.

%%
%Gaussian filter ����
filterSize = 2*round(2*Gaussian_sigma)+1;
halfFs = (filterSize-1)/2;
% ������ ���ϴ�, ������ ��ǥ���� ���ؼ� ������ ũ�⸦ ���Ѵ�.
weight = zeros(filterSize, filterSize);
% 0���� ������ gaussian filter�� weight��� ��ķ� ����
for y = -halfFs : halfFs 
    for x = -halfFs : halfFs 
        weight(y+halfFs+1,x+halfFs+1) = 1/(2*pi*Gaussian_sigma^2) * ...
            exp(-(y^2+x^2) / (2*Gaussian_sigma^2));
        % ��� weight�� �� ��� ���� ���� �Է��������ν� weight���� �Էµ� gaussian filter ����
    end
end
weight = weight / sum(weight, 'all'); %weight���� ���Ե� gaussian filter�� ����

%%
%Gaussian filter ����
Gaussian_fx2 = zeros(size(fx2));
Gaussian_fy2 = zeros(size(fy2));
Gaussian_fxfy = zeros(size(fxfy));

%fx�� ����, fy�� ����, fx�� fy�� �� ���� gaussian filter�� ������ �ִ� ����
for y = 1:size(im,1) % im�� result�� ���� ���� ����
    for x = 1:size(im,2)
        % im�� result�� �ʺ� ���� ����
        for s = -halfFs:halfFs % ������ ���� ���� ����
            for t = -halfFs:halfFs % ������ �ʺ� ���� ����
                ys = y-s;
                xt = x-t;
                % ������ ��� ���� �������� ������ �� ��ǥ�� �����Ǵ�
                % im������ ��ǥ�� ys, xt�� ��Ÿ��
                if ys <1; ys = 1; end; if xt <1; xt = 1; end
                if ys > size(im,1); ys = size(im,1); end;if xt > size(im,2); xt = size(im,2); end
                % replicate padding ����� ������ �ڵ�
                % ���Ͱ� y �� 0���� �۰ų� size(im,1)���� ū ��ǥ�� ���̳�
                % x�� 0���� �۰ų� size(im,2)���� ū ��ǥ�� ���� ����ؼ� ����Ϸ��� �Ҷ�
                % replicate padding�� ���ؼ� ���� �Ʊ�� pixel�� ���� ����ϵ��� �ڵ��Ͽ���

                Gaussian_fx2(y,x) = Gaussian_fx2(y,x) + weight(s+halfFs+1,t+halfFs+1)*fx2(ys,xt);
                Gaussian_fy2(y,x) = Gaussian_fy2(y,x) + weight(s+halfFs+1,t+halfFs+1)*fy2(ys,xt);
                Gaussian_fxfy(y,x) = Gaussian_fxfy(y,x) + weight(s+halfFs+1,t+halfFs+1)*fxfy(ys,xt);
            end
        end
   end
end
%%
%cornerness score
cornerness = zeros(size(im)); %cornerness score map�� ����� �ش�.
for y = 1:size(im,1)
    for x = 1:size(im,2)
        cornerness(y,x) = Gaussian_fx2(y,x)*Gaussian_fy2(y,x) - Gaussian_fxfy(y,x)^2 ...
            -alpha*(Gaussian_fx2(y,x)+Gaussian_fy2(y,x))^2;
    end
end
C = cornerness; %����� cornerness score map�� C ������ ����
threshold = C_thres*max(cornerness,[],'all');
win = zeros(NMS_ws,NMS_ws);
halfFs = (NMS_ws-1)/2;
corner=[]; %interest point�� x,y��ǥ�� ������ corner��� ��� ����
% �� pixel �ֺ����� 7*7 size�� ���� window�� �����ϰ� �� ���鿡 ���ؼ� ���� �����ϴ� ����
for y = 1:size(im,1)
    for x = 1:size(im,2)
        for s = -halfFs:halfFs % ������ ���� ���� ����
            for t = -halfFs:halfFs % ������ �ʺ� ���� ����
                ys = y-s;
                xt = x-t;
                % ������ ��� ���� �������� ������ �� ��ǥ�� �����Ǵ�
                % im������ ��ǥ�� ys, xt�� ��Ÿ��
                if ys <1; ys = 1; end; if xt <1; xt = 1; end
                if ys > size(im,1); ys = size(im,1); end; if xt > size(im,2); xt = size(im,2); end
                win(s+halfFs+1,t+halfFs+1) = cornerness(ys,xt);
            end
        end
        % �ش� pixel�� threshold���� ũ�� �ֺ����� ������ 7*7 window ������
        % ���� ū ���� ��, interest point(corner)�� �����Ͽ� x,y ��ǥ ����
        if cornerness(y,x) > threshold
            if cornerness(y,x) == max(win,[],'all')
                corner = [corner; [x y]];
                % ������ interest point(corner)�� ���ʴ�� �����Ѵ�.
            end
        end
    end
end
end
        