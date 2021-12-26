close all; clear all; clc;

im = imread('Lenna_salt_pepper.png');
% input image 'Lenna_sat_pepper.png'�� �ȼ� �������� im���� ������ ����
im = im2double(im);
% im�� ������ uint8���� double������ ����
sigma = 5;
% sigma ���� 10���� ����

result = gaussianFiltering(im, sigma);
% im�� gaussian filtering�� ����� result�� ����

imwrite(result, 'result_GaussianFilter.png'); 
% result�� ������ 'result_GaussianFilter.png'�� ����

close all; clear all; clc;
im = imread('Lenna_salt_pepper.png');
result_medianFilter.png
filterSize = [3,3];
% filter�� size�� 3x3 filter�� ����

result = medianFiltering(im, filterSize);
% im�� median filtering�� ����� result�� ����
imwrite(result, 'result_medianFilter.png'); 
% result�� ������ 'result_medianFilter.png'�� ����
