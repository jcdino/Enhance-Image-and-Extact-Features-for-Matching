function SIFT = extractSIFT(im, fx_operator, fy_operator, corner, Gaussian_sigma)
%%
im = double(rgb2gray(im)); %im�� rgb���� gray scale�� �ٲٰ� 
                           %��Ȯ�� ���� ���ϱ� ���� uint8���� double�� ��ȯ
fx = zeros(size(im)); fy = zeros(size(im));

% x����� y���⿡ ���� derivatives�� ���� ���ϰ� �̸� ��ķ� ǥ����
for y=1:size(im,1)
    for x=1:size(im,2)
        a = x+1;
        b = y+1;
        if a>size(im,2); a=x;end
        if b>size(im,1); b=y;end
        fx(y,x) = im(y,x)*fx_operator(1,1)+im(y,a)*fx_operator(1,2);
        fy(y,x) = im(y,x)*fy_operator(1,1)+im(b,x)*fy_operator(2,1);
    end
end

%%
M = zeros(size(im));
direction = zeros(size(im));
% gradient�� magnitude�� direction�� �����
% gradient�� direction�� ��쿡�� atan�� -pi/2���� pi/2���� ǥ�� �����ϹǷ� 
% �� ���� ������ ���ؼ��� pi�� �����ְ� ���־���.
for y=1:size(im,1)
    for x=1:size(im,2)
        M(y,x) = sqrt(fx(y,x)^2+fy(y,x)^2);
        if fx(y,x)<0 && fy(y,x)>0
            direction(y,x) = atan(fy(y,x)/fx(y,x))+pi;
        elseif fx(y,x)<0 && fy(y,x)<0
            direction(y,x) = atan(fy(y,x)/fx(y,x))-pi;
        elseif fx(y,x)==0 && fy(y,x)<0
            direction(y,x) = -pi/2;
        elseif fx(y,x)==0 && fy(y,x)>0
            direction(y,x) = pi/2;
        elseif fx(y,x)<0 && fy(y,x)==0
            direction(y,x) = pi;
        elseif fx(y,x)>0 && fy(y,x)==0
            direction(y,x) = pi/2;
        else 
            direction(y,x) = atan(fy(y,x)/fx(y,x));
        end
    end
end
%%

%Gaussian filter ����
filterSize = 16;

halfFs = (filterSize)/2;
% ������ ���ϴ�, ������ ��ǥ���� ���ؼ� ������ ũ�⸦ ���Ѵ�.

weight = zeros(filterSize, filterSize);
% 0���� ������ gaussian filter�� weight��� ��ķ� ����

for y = -halfFs+1 : halfFs 
    for x = -halfFs+1 : halfFs 
        weight(y+halfFs,x+halfFs) = 1/(2*pi*Gaussian_sigma^2) * ...
            exp(-((y-0.5)^2+(x-0.5)^2) / (2*Gaussian_sigma^2));
        % ��� weight�� �� ��� ���� ���� �Է��������ν� weight���� �Էµ� gaussian filter ����
    end
end
weight = weight / sum(weight, 'all');

%%

filterSize = 16; halfFs = filterSize/2;
crop_M  =zeros(16,16); crop_direction = zeros(16,16);
hist = zeros(128,size(corner,1));new_hist = zeros(128,size(corner,1));
% SIFT�� ������� 128-D vector�� �����ϱ� ���� for��
for y = 1:size(corner,1)
    for s = -halfFs+1:halfFs % ������ ���� ���� ����
        for t = -halfFs+1:halfFs % ������ �ʺ� ���� ����
            ys = corner(y,2)+s;
            xt = corner(y,1)+t;
            % ������ ��� ���� �������� ������ �� ��ǥ�� �����Ǵ� im������ ��ǥ�� ys, xt�� ��Ÿ��
            if ys <1; ys = 1; end; if xt <1; xt = 1; end
            if ys > size(im,1); ys = size(im,1); end; if xt > size(im,2); xt = size(im,2); end
            %magnitute�� direction�� ���ؼ� 16*16�� patch�� crop�Ѵ�.
            crop_M(s+halfFs,t+halfFs) = M(ys,xt);
            crop_direction(s+halfFs,t+halfFs) = direction(ys,xt);
        end
    end
    % Crop�� magnitute patch�� Gaussian function�� �����Ͽ���.
    Gaussian_crop_M = crop_M.*weight;
    count = 1;
    for y_crop = 1:4
        for x_crop = 1:4
            for y_dir = 1:4
                for x_dir = 1:4
                    for dir = 1 : 8
                        % 16+16 patch�� 4�� �������� �з��Ͽ� �� ���������� ���⿡ �����ϴ� ������
                        % ũ�⸦ histogram�� �����Ѵ�.
                        if (crop_direction(y_dir+4*(y_crop-1), x_dir+4*(x_crop-1)) >= -pi+2*pi/8*(dir-1)) ...
                                &&(crop_direction(y_dir+4*(y_crop-1),x_dir+4*(x_crop-1))<-pi+2*pi/8*(dir))
                            hist(dir+8*(count-1),y) = hist(dir+8*(count-1),y) +...
                                Gaussian_crop_M(y_dir+4*(y_crop-1), x_dir+4*(x_crop-1));
                        end
                    end
                end
            end
            count = count + 1;        
        end 
    end
    for idx = 1:size(hist,2)
        hist_sum = 0;
        for d = 1:size(hist,1)
            % 128-D vector�� ����ȭ �ϱ� ���� ���� �����ش�.
            hist_sum = hist_sum + hist(d,idx)^2;
        end
        for d = 1:size(hist,1)
            new_hist(d,idx) = hist(d,idx) / sqrt(hist_sum); % 128-D vector ����ȭ
            if new_hist(d,idx)<0.2 % 0.2���� ���� ���� 0���� ������ش�. 
                new_hist(d,idx)=0;
            end
        end
        for d = 1:size(hist,1)
            % 128-D vector�� �ٽ� ����ȭ �ϱ� ���� ���� �����ش�.
            hist_sum = hist_sum + hist(d,idx)^2;
        end
        for d = 1:size(hist,1)
            % 128-D vector �ٽ� ����ȭ
            new_hist(d,idx) = hist(d,idx) / sqrt(hist_sum);
        end
    end
end
SIFT = new_hist;%���� ������ 128-D histogram ���
end    