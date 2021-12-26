
function result = blend(im1,im2,alpha)

result = zeros(size(im1),'uint8');
%im1�� im2�� size�� ������ Ȯ���� ��, result�� im1�� size�� ���� zero�� �̷���� ��ķ� �����ߴ�.
%zeros()�Լ��� ����ϸ� double Ȯ���ڷ� ���ǵǹǷ� uint8 ���·� ���ǵ� �� �ֵ��� �����Ѵ�.
for ch = 1:size(im1,3)
    %im1�� size()�Լ��� ����ؼ� ����ch�� 1���� im1�� channel�������� ���������� ���ϵ��� for���� �����ߴ�. 
    for y = 1:size(im1,1)
        %im1�� size()�Լ��� ����ؼ� ����y�� 1���� im1�� hight�������� ���������� ���ϵ��� for���� �����ߴ�. 
        for x = 1:size(im1,2)
            %im1�� size()�Լ��� ����ؼ� ����x�� 1���� im1�� width�������� ���������� ���ϵ��� for���� �����ߴ�.
            
            result(y,x,ch) = alpha*im1(y,x,ch)+(1-alpha)*im2(y,x,ch);
            %��� result�� ��ǥ�� channel�� ������ im1�� im2�� ���� ���� alpha,
            %(1-alpha)��ŭ�� ����ġ�� �༭ ��� result�� ��ǥ�� ������ �����Ͽ� ��� result�� �ϼ��Ͽ���.
            %��� result�� �� ��Ŀ� �ԷµǴ� ���� 255�� �Ѿ�� �ʵ��� 
            %������ ���� alpha�� (1-alpha)���� �����༭ �ִ밪�� 255�� �Ѿ�� �ʵ��� �Ѵ�.
        end
    end
end
end





