%��������1��ţ�2ʱ�䣬3ʵ��ת4cmdת��5������,6�ٶ��򣬣�7Ť��

clc; clear;
%% �ĳ��Լ���·��
data = xlsread('/Users/we/Desktop/my_predict/steering_data.xlsx','sheet2');

%% ��ǰ��real1��cmd1�Ĳ�ֵ ��Ӧfigure��5���к�ɫ

x1 = (11:11225)/50;         % ÿ�����ݵļ��Ϊ0.02s
real = data(11:11225, 3)';
cmd1 = data(11:11225, 4)';
e1 = cmd1 - real;

% figure(1)
% plot(x1, real, 'g', x1, cmd1, 'r') 
% figure(2)
% plot(x1, e1,'r')

%% 0.2sǰ��cmd2�����ڵ�real2�Ĳ�ֵ ��Ӧfigure��5������ɫ
x2 = (11:11225)/50;
real2 = data(11:11225, 3)';
cmd2 = data(1:11215, 4)';
e2 = cmd2 - real2;

% figure(3)
% plot(x2, real2, 'g', x2, cmd2, 'r')
% figure(4)
% plot(x2, e2,'b')

%%
figure(5)
plot(x1, e1,'r',x2, e2,'b')     % figure(2)��figure(4)�����Ա�

square1 = sum(e1.^2)/11215      % �����
square2 = sum(e2.^2)/11215      % ȥ��0.2s��ʱ�����
difference = square1 - square2
ratio = difference/square1     % ��ʱ���µ�����������ռ��
