
close all; clear all; clc;

im = imread('Lenna.png');
% im������ 'Lenna.png'�� pixel������ �ҷ��´�.
scale = 2;
% �Է� ���� �������� �þ�� pixel�� ����� ���� scale������ �������ش�.

result = bilinearInterpolation(im, scale);
% im�� scale�� parameter�� �� �Լ� bilinearInterpolation()�� ������ ����� ���� result��
% �������ش�,
imwrite(result, 'result_bilinearInterpolation.png'); 
% result�� ����� 'result_bilnearInterpolation.png'��� ���ϸ����� ������ �����Ѵ�.

%%

close all; clear all; clc;

im = imread('Lenna_salt_pepper.png');
% im������ 'Lenna_salt_pepper.png'�� pixel������ �ҷ��´�.

result = SobelEdge(im);
% im�� parameter�� �� �Լ� SobelEdge()�� ������ ����� ���� result�� �������ش�,
imwrite(result, 'result_SobelEdge.png'); 
% result�� ����� 'result_SobelEdge.png'��� ���ϸ����� ������ �����Ѵ�.

im = medfilt2(im);
% �Է� ������ median filter�� ���� noise ���Ÿ� ���־���.
result = SobelEdge(im);
% im�� parameter�� �� �Լ� SobelEdge()�� ������ ����� ���� result�� �������ش�,
imwrite(result, 'result_SobelEdge_medianFilter.png'); 
% result�� ����� 'result_SobelEdge_medianFilter.png'��� ���ϸ����� ������ �����Ѵ�.
