%��������1��ţ�2ʱ�䣬3ʵ��ת��4cmdת��5������,6�ٶȣ�7Ť��

data=xlsread('D:/science/neuralnetwork/sourcecode/predictrealdata/steering_data.xlsx','sheet2');


input = [data(11:6000, [4, 6, 7, 3]); data(7001:11211, [4, 6, 7, 3])]';
output = [data(15:6004, 4) - data(15:6004, 3); data(7005:11215, 4) - data(7005:11215, 3)]';


% ѵ����ûЧ���������������ѡȡ�����⣬����û�й�һ����ԭ��
% �����Ҫ�Ľ���ǿ�������ǰ�����ʵ��������һʱ�̵�3-4�������ƣ���

net = newff(input,output,[8,6],{'tansig', 'tansig'}, 'traingdx'); % 'traingdx'��Ȩֵ��ѵ���㷨,�����ppt25ҳ
net.trainParam.epochs = 5000;       % [20,20]������20�ڵ�������㣬3�����룬1�������
net.trainParam.goal = 1e-10;
net.trainParam.lr = 0.01 ;              % ѧϰ��
% net.divideFcn = '';                    
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio   = 15/100;
net.divideParam.testRatio  = 15/100;
net.trainParam.max_fail = 20;


net = train(net, input, output);        % ѵ�����磬û�й�һ��������
tic;
input_test = data(7001:7990, [4, 6, 7, 3])';
output_true = (data(7005:7994, 4) - data(7005:7994, 3))';
predict_errL = sim(net, input_test);
% predict_errB = sim(net, input_test);      % �������
toc;
% xB = (7005:7994)/50;
xL = (7005:7994)/50;
%%
figure(1)
% plot(xB,predict_errB,'LineWidth',1,'color','r')
plot(xL,predict_errL,'LineWidth',1,'color','G')
hold on;
% plot(xB,output_true,'LineWidth',2,'color','k')
hold off;
% xlabel('time (s)')
% ylabel('steering wheel angle error (rad)')
% legend('BP predicted','measured')
% �鿴�������Ա༭���������ֺ�

e = predict_errB - output_true;          % ����ɺ��ŵ�һ��
MSE = sum(e.^2)/990          % 0.0171   0.0163 
RMSE = MSE^0.5               % 0.131    0.128
MAE = sum(abs(e))/990