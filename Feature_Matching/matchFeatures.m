
function matching = matchFeatures(SIFT1, SIFT2)

matching = []; %���� matching�� �̷���� ������ ������ ���

% SIFT1������ �� interest point�� ���ؼ� SIFT2���� ������ interets point ã�� ����
for corners_1 = 1:size(SIFT1,2)
    NN1 = inf; NN2 = inf; NN1_idx = 0;
    for corners_2 = 1:size(SIFT2,2)
        distance = 0;
        for D = 1:128
            distance = distance + (SIFT1(D,corners_1) - SIFT2(D,corners_2))^2;
            % SIFT1�� �� ���� ���� 128���� ���� �׿� �����ϴ� SIFT2�� 128���� ���� ���� �����Ͽ�
            %�̸� distance�� �����Ѵ�.
        end
        % ���� ������ ���� distance�� NN1, �ι�°�� ������ ���� distance�� NN2�� �����Ѵ�
        if distance<=NN1
            NN1 = distance;
            NN1_idx = corners_2;
        elseif distance<NN2 && distance>NN1
            NN2 = distance;
        else
            continue;
        end
    end
    % matching ��Ŀ� distance�� ���� ����� SIFT2�� index�� radio distance�� ����
    matching = [matching; [NN1_idx NN1/NN2]];
end
            
                    