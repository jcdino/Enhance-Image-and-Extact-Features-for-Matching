
function result = histEq(im, n)

%histogram ����
[H, W] = size(im);
hist = zeros(n,1); %column vector
new_im = zeros(size(im));
for h=1:H
    for w = 1:W
        new_im(h,w) = im(h,w);
        % �ڿ� �Ի꿡�� num�� 255�� �Ѿ�� �� ���� �����ϱ� ����
        % uint8������ im�� double������ ������ ���� ��ķ� �ٽ� ������
    end
end
m = (255/n);
for h=1:H
    for w = 1:W
        num = round(new_im(h,w)/m);
        % 0~255���� �����ϴ� im�� �� pixel ������ 255�� ������ n���� ���ؼ� 
        % pixel ������ 0~n level�� �з��� �ǵ��� ��
        hist(num+1) = hist(num+1)+1; 
        % histogram�� ������ num��° bin�� num ������ �󵵼��� ����
    end
end
figure; bar(0:n-1,hist);
% histogram figure1 ����

% Equalizaton
prob = hist / (H*W);
% normalized�� histogram ����
figure; plot(0:n-1, prob);
% normalized�� histogram�� figure2 ����


cum_prob = zeros(n,1);
cum_prob(1) = prob(1);
for k=2:n
    cum_prob(k) = cum_prob(k-1)+prob(k);
    % normalized�� histogram�� ���� cumulative histogram ����
end
figure; plot(cum_prob)
% cumulative histogram�� figure3 ����

target = (n-1)*cum_prob;
% normailized�� cumulative histogram ������ histogram�� level ���� �µ��� (n-1)�� ����
figure; plot(target, '*-')
% target�� ���� figure4 ����

target_round = round(target); 
% level������ ��� �����̹Ƿ� target���� ������ �ݿø�
figure; plot(target_round, '*-');
% target_round�� ���� figure5 ����

new_target_round = zeros(256,1);
for i= 1:n
    for p = round((255/n)*(i-1)):round((255/n)*i)
        new_target_round(p+1) = target_round(i)*m;
        % ��� ������ pixel������ ������ ������׷��� level �����Ⱑ 0~255�� �ǵ��� �ؾ��ϹǷ� 
        %level�� ��� ������ ������ 0~255�� ��� new_target_round()�� ���� ������
    end
end
figure; plot(new_target_round,'*-');
% new_target_round()�� ���� figure6 ����

result = zeros(size(im), 'uint8');
for h = 1:H
    for w = 1:W
        result(h,w) = new_target_round(im(h,w));
        %result�� �� pixel�� histogram equalizaiton�̵� ���� �����Ѵ�.
    end
end





