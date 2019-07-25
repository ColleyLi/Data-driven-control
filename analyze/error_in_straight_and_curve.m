%��������1��ţ�2ʱ�䣬3ʵ��ת��4cmdת��5������,6�ٶȣ�7Ť��

clc; clear;
data = xlsread('/Users/zch/Desktop/ʱ����NN���/my_predict/steering_data.xlsx','sheet2');
real = data(1:11225, 3)';
cmd1 = data(1:11225, 4)';

straight = 0;
curve = 0;
num1 = 0;
num2 = 0;
for i = 1:11225
    a = data(i,4);
    if abs(a)<0.1   % ֱ��
        straight = straight + data(i,5)^2;    % error��ƽ����    
        num1 = num1 +1;
    else            % ���
        curve = curve + data(i,5)^2;  
        num2 = num2 +1;
    end
end

MSE_straight = straight/num1;
MSE_curve = curve/num2;
RMSE_straight = MSE_straight^0.5
RMSE_curve = MSE_curve^0.5
